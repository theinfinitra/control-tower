#!/bin/bash

# Deploy Legacy Resources for AWS Control Tower Training
# Usage: ./deploy-legacy-resources.sh [OPTIONS]
# Examples:
#   ./deploy-legacy-resources.sh --team 1 --env prod --profile techcorp-team1-existing-prod --region us-east-1
#   ./deploy-legacy-resources.sh --all --region us-west-2
#   ./deploy-legacy-resources.sh --team 2 --env dev --profile my-dev-profile

set -e

# Default configuration
DEFAULT_REGION="us-east-1"
STACK_PREFIX="legacy-resources"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_usage() { echo -e "${BLUE}[USAGE]${NC} $1"; }

# Usage function
usage() {
    echo "Deploy Legacy Resources for AWS Control Tower Training"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --team TEAM          Team number (1 or 2)"
    echo "  --env ENV            Environment (prod or dev)"
    echo "  --profile PROFILE    AWS CLI profile name"
    echo "  --region REGION      AWS region (default: us-east-1)"
    echo "  --all                Deploy to all default team accounts"
    echo "  --cleanup            Remove all legacy resources"
    echo "  --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --team 1 --env prod --profile techcorp-team1-existing-prod"
    echo "  $0 --team 2 --env dev --profile my-custom-profile --region us-west-2"
    echo "  $0 --all"
    echo "  $0 --cleanup"
    echo ""
    echo "Default profiles (when using --all):"
    echo "  Team 1 Prod: techcorp-team1-existing-prod"
    echo "  Team 1 Dev:  techcorp-team1-existing-dev"
    echo "  Team 2 Prod: techcorp-team2-existing-prod"
    echo "  Team 2 Dev:  techcorp-team2-existing-dev"
}

# Parse command line arguments
TEAM=""
ENVIRONMENT=""
PROFILE=""
REGION="$DEFAULT_REGION"
DEPLOY_ALL=false
CLEANUP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --team)
            TEAM="$2"
            shift 2
            ;;
        --env)
            ENVIRONMENT="$2"
            shift 2
            ;;
        --profile)
            PROFILE="$2"
            shift 2
            ;;
        --region)
            REGION="$2"
            shift 2
            ;;
        --all)
            DEPLOY_ALL=true
            shift
            ;;
        --cleanup)
            CLEANUP=true
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validation functions
validate_team() {
    if [[ "$1" != "1" && "$1" != "2" ]]; then
        print_error "Team must be 1 or 2, got: $1"
        exit 1
    fi
}

validate_environment() {
    if [[ "$1" != "prod" && "$1" != "dev" ]]; then
        print_error "Environment must be 'prod' or 'dev', got: $1"
        exit 1
    fi
}

check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        print_error "AWS CLI is not installed. Please install it first."
        exit 1
    fi
}

check_profile() {
    local profile=$1
    if ! aws configure list-profiles | grep -q "^${profile}$"; then
        print_error "AWS profile '${profile}' not found. Available profiles:"
        aws configure list-profiles | sed 's/^/  /'
        exit 1
    fi
    
    if ! aws sts get-caller-identity --profile "$profile" &> /dev/null; then
        print_error "Cannot authenticate with profile '${profile}'. Please check credentials."
        exit 1
    fi
}

check_template() {
    local template=$1
    if [[ ! -f "$template" ]]; then
        print_error "Template file not found: $template"
        print_error "Make sure you're running this script from the cloudformation directory."
        exit 1
    fi
}

# Deploy function
deploy_stack() {
    local team=$1
    local env=$2
    local profile=$3
    local region=$4
    
    validate_team "$team"
    validate_environment "$env"
    check_profile "$profile"
    
    local template_file="legacy-${env}duction-resources.yaml"
    if [[ "$env" == "dev" ]]; then
        template_file="legacy-development-resources.yaml"
    else
        template_file="legacy-production-resources.yaml"
    fi
    
    check_template "$template_file"
    
    local stack_name="${STACK_PREFIX}-team${team}-${env}"
    local account_id=$(aws sts get-caller-identity --profile "$profile" --query 'Account' --output text)
    
    print_status "Deploying to Account: $account_id, Team: $team, Environment: $env, Region: $region"
    print_status "Using profile: $profile, Template: $template_file"
    
    # Check if stack exists
    if aws cloudformation describe-stacks --stack-name "$stack_name" --profile "$profile" --region "$region" &> /dev/null; then
        print_warning "Stack $stack_name already exists. Updating..."
        aws cloudformation update-stack \
            --stack-name "$stack_name" \
            --template-body "file://$template_file" \
            --parameters ParameterKey=TeamNumber,ParameterValue="$team" \
                        ParameterKey=Environment,ParameterValue="$env" \
            --capabilities CAPABILITY_NAMED_IAM \
            --profile "$profile" \
            --region "$region"
        
        print_status "Waiting for stack update to complete..."
        aws cloudformation wait stack-update-complete \
            --stack-name "$stack_name" \
            --profile "$profile" \
            --region "$region"
    else
        print_status "Creating new stack $stack_name..."
        aws cloudformation create-stack \
            --stack-name "$stack_name" \
            --template-body "file://$template_file" \
            --parameters ParameterKey=TeamNumber,ParameterValue="$team" \
                        ParameterKey=Environment,ParameterValue="$env" \
            --capabilities CAPABILITY_NAMED_IAM \
            --profile "$profile" \
            --region "$region"
        
        print_status "Waiting for stack creation to complete..."
        aws cloudformation wait stack-create-complete \
            --stack-name "$stack_name" \
            --profile "$profile" \
            --region "$region"
    fi
    
    print_status "✅ Stack $stack_name deployed successfully!"
    
    # Show outputs
    print_status "Stack outputs:"
    aws cloudformation describe-stacks \
        --stack-name "$stack_name" \
        --profile "$profile" \
        --region "$region" \
        --query 'Stacks[0].Outputs[*].[OutputKey,OutputValue]' \
        --output table
}

# Deploy all function
deploy_all() {
    local region=$1
    
    print_status "Deploying to all default team accounts in region: $region"
    
    # Team 1 accounts
    if aws configure list-profiles | grep -q "techcorp-team1-existing-prod"; then
        deploy_stack "1" "prod" "techcorp-team1-existing-prod" "$region"
    else
        print_warning "Profile 'techcorp-team1-existing-prod' not found. Skipping Team 1 production."
    fi
    
    if aws configure list-profiles | grep -q "techcorp-team1-existing-dev"; then
        deploy_stack "1" "dev" "techcorp-team1-existing-dev" "$region"
    else
        print_warning "Profile 'techcorp-team1-existing-dev' not found. Skipping Team 1 development."
    fi
    
    # Team 2 accounts
    if aws configure list-profiles | grep -q "techcorp-team2-existing-prod"; then
        deploy_stack "2" "prod" "techcorp-team2-existing-prod" "$region"
    else
        print_warning "Profile 'techcorp-team2-existing-prod' not found. Skipping Team 2 production."
    fi
    
    if aws configure list-profiles | grep -q "techcorp-team2-existing-dev"; then
        deploy_stack "2" "dev" "techcorp-team2-existing-dev" "$region"
    else
        print_warning "Profile 'techcorp-team2-existing-dev' not found. Skipping Team 2 development."
    fi
}

# Cleanup function
cleanup_all() {
    print_warning "This will delete ALL legacy resource stacks from all accounts!"
    read -p "Are you sure? Type 'DELETE' to confirm: " confirm
    
    if [[ "$confirm" != "DELETE" ]]; then
        print_status "Cleanup cancelled."
        exit 0
    fi
    
    local profiles=("techcorp-team1-existing-prod" "techcorp-team1-existing-dev" 
                   "techcorp-team2-existing-prod" "techcorp-team2-existing-dev")
    
    for profile in "${profiles[@]}"; do
        if aws configure list-profiles | grep -q "^${profile}$"; then
            local team=$(echo "$profile" | grep -o 'team[12]' | grep -o '[12]')
            local env="prod"
            if [[ "$profile" == *"dev"* ]]; then
                env="dev"
            fi
            
            local stack_name="${STACK_PREFIX}-team${team}-${env}"
            
            if aws cloudformation describe-stacks --stack-name "$stack_name" --profile "$profile" --region "$REGION" &> /dev/null; then
                print_status "Deleting stack $stack_name from profile $profile..."
                aws cloudformation delete-stack --stack-name "$stack_name" --profile "$profile" --region "$REGION"
                aws cloudformation wait stack-delete-complete --stack-name "$stack_name" --profile "$profile" --region "$REGION"
                print_status "✅ Stack $stack_name deleted successfully!"
            fi
        fi
    done
    
    print_status "Cleanup completed!"
}

# Main execution
check_aws_cli

if [[ "$CLEANUP" == true ]]; then
    cleanup_all
    exit 0
fi

if [[ "$DEPLOY_ALL" == true ]]; then
    deploy_all "$REGION"
    exit 0
fi

# Single deployment
if [[ -z "$TEAM" || -z "$ENVIRONMENT" || -z "$PROFILE" ]]; then
    print_error "Missing required parameters for single deployment."
    print_error "Use --team, --env, and --profile together, or use --all for bulk deployment."
    echo ""
    usage
    exit 1
fi

deploy_stack "$TEAM" "$ENVIRONMENT" "$PROFILE" "$REGION"

print_status "🎉 Deployment completed successfully!"
print_warning "IMPORTANT: These resources create Control Tower guardrail violations for training purposes."
