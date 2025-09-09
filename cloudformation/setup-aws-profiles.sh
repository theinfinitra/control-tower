#!/bin/bash

# Setup AWS CLI Profiles for Control Tower Training
# Usage: ./setup-aws-profiles.sh [OPTIONS]
# Examples:
#   ./setup-aws-profiles.sh --all
#   ./setup-aws-profiles.sh --profile techcorp-team1-existing-prod --account 123456789012
#   ./setup-aws-profiles.sh --verify

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_instruction() { echo -e "${BLUE}[INSTRUCTION]${NC} $1"; }

# Usage function
usage() {
    echo "Setup AWS CLI Profiles for Control Tower Training"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all                Setup all default training profiles"
    echo "  --profile PROFILE    Setup specific profile name"
    echo "  --account ACCOUNT    Expected account ID for validation"
    echo "  --verify             Verify all existing profiles"
    echo "  --cleanup            Remove all training profiles"
    echo "  --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --all"
    echo "  $0 --profile techcorp-team1-existing-prod --account 123456789012"
    echo "  $0 --verify"
    echo "  $0 --cleanup"
    echo ""
    echo "Default profiles (when using --all):"
    echo "  techcorp-team1-master"
    echo "  techcorp-team1-existing-prod"
    echo "  techcorp-team1-existing-dev"
    echo "  techcorp-team2-master"
    echo "  techcorp-team2-existing-prod"
    echo "  techcorp-team2-existing-dev"
}

# Parse command line arguments
SETUP_ALL=false
PROFILE_NAME=""
EXPECTED_ACCOUNT=""
VERIFY_ONLY=false
CLEANUP_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            SETUP_ALL=true
            shift
            ;;
        --profile)
            PROFILE_NAME="$2"
            shift 2
            ;;
        --account)
            EXPECTED_ACCOUNT="$2"
            shift 2
            ;;
        --verify)
            VERIFY_ONLY=true
            shift
            ;;
        --cleanup)
            CLEANUP_ONLY=true
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

# Function to setup a single AWS profile
setup_profile() {
    local profile_name=$1
    local account_description=$2
    local expected_account=$3
    
    print_status "Setting up profile: ${profile_name}"
    print_instruction "Description: ${account_description}"
    
    if [[ -n "$expected_account" ]]; then
        print_instruction "Expected Account ID: ${expected_account}"
    fi
    
    echo ""
    echo "Please enter the AWS credentials for ${profile_name}:"
    
    # Get AWS Access Key ID
    read -p "AWS Access Key ID: " access_key_id
    if [[ -z "$access_key_id" ]]; then
        print_error "Access Key ID cannot be empty"
        return 1
    fi
    
    # Get AWS Secret Access Key
    read -s -p "AWS Secret Access Key: " secret_access_key
    echo ""
    if [[ -z "$secret_access_key" ]]; then
        print_error "Secret Access Key cannot be empty"
        return 1
    fi
    
    # Set default region
    local region="us-east-1"
    read -p "Default region [us-east-1]: " input_region
    if [[ -n "$input_region" ]]; then
        region="$input_region"
    fi
    
    # Configure the profile
    aws configure set aws_access_key_id "$access_key_id" --profile "$profile_name"
    aws configure set aws_secret_access_key "$secret_access_key" --profile "$profile_name"
    aws configure set region "$region" --profile "$profile_name"
    aws configure set output "json" --profile "$profile_name"
    
    # Test the profile
    print_status "Testing profile ${profile_name}..."
    if aws sts get-caller-identity --profile "$profile_name" &> /dev/null; then
        local actual_account=$(aws sts get-caller-identity --profile "$profile_name" --query 'Account' --output text)
        
        # Validate account ID if expected
        if [[ -n "$expected_account" && "$actual_account" != "$expected_account" ]]; then
            print_error "❌ Account ID mismatch!"
            print_error "   Expected: $expected_account"
            print_error "   Actual:   $actual_account"
            print_warning "Profile configured but account validation failed."
            return 1
        fi
        
        print_status "✅ Profile ${profile_name} configured successfully! Account ID: ${actual_account}"
    else
        print_error "❌ Failed to configure profile ${profile_name}. Please check credentials."
        return 1
    fi
    
    echo ""
}

# Function to verify all profiles
verify_profiles() {
    print_status "Verifying all configured training profiles..."
    
    local profiles=("techcorp-team1-master" "techcorp-team1-existing-prod" "techcorp-team1-existing-dev" 
                   "techcorp-team2-master" "techcorp-team2-existing-prod" "techcorp-team2-existing-dev")
    
    local success_count=0
    local total_count=0
    
    for profile in "${profiles[@]}"; do
        if aws configure list-profiles | grep -q "^${profile}$"; then
            ((total_count++))
            if aws sts get-caller-identity --profile "$profile" &> /dev/null; then
                local account_id=$(aws sts get-caller-identity --profile "$profile" --query 'Account' --output text)
                local region=$(aws configure get region --profile "$profile")
                echo "  ✅ ${profile} - Account: ${account_id} - Region: ${region}"
                ((success_count++))
            else
                echo "  ❌ ${profile} - Authentication failed"
            fi
        fi
    done
    
    # Check for any other techcorp profiles
    local other_profiles=$(aws configure list-profiles | grep techcorp | grep -v -E "(team1|team2)-(master|existing-(prod|dev))")
    if [[ -n "$other_profiles" ]]; then
        echo ""
        print_status "Other techcorp profiles found:"
        echo "$other_profiles" | while read profile; do
            if aws sts get-caller-identity --profile "$profile" &> /dev/null; then
                local account_id=$(aws sts get-caller-identity --profile "$profile" --query 'Account' --output text)
                echo "  ✅ ${profile} - Account: ${account_id}"
                ((success_count++))
                ((total_count++))
            else
                echo "  ❌ ${profile} - Authentication failed"
                ((total_count++))
            fi
        done
    fi
    
    echo ""
    print_status "Verification complete: ${success_count}/${total_count} profiles working"
    
    if [[ $success_count -eq $total_count && $total_count -gt 0 ]]; then
        print_status "🎉 All profiles are configured and working correctly!"
        return 0
    elif [[ $total_count -eq 0 ]]; then
        print_warning "No training profiles found. Run with --all to set them up."
        return 1
    else
        print_warning "Some profiles need attention. Please reconfigure failed profiles."
        return 1
    fi
}

# Function to clean up profiles
cleanup_profiles() {
    print_warning "This will remove all techcorp training profiles from AWS CLI configuration."
    read -p "Are you sure? Type 'DELETE' to confirm: " confirm
    
    if [[ "$confirm" != "DELETE" ]]; then
        print_status "Cleanup cancelled."
        return 0
    fi
    
    print_status "Removing training profiles..."
    
    local removed_count=0
    aws configure list-profiles | grep techcorp | while read profile; do
        print_status "Removing profile: ${profile}"
        # Remove the profile section from credentials and config files
        aws configure --profile "$profile" set aws_access_key_id ""
        aws configure --profile "$profile" set aws_secret_access_key ""
        aws configure --profile "$profile" set region ""
        aws configure --profile "$profile" set output ""
        ((removed_count++))
    done
    
    print_status "Profile cleanup completed! Removed profiles: $removed_count"
}

# Main setup function
setup_all_profiles() {
    print_status "AWS Control Tower Training - Profile Setup"
    print_status "This script will help you configure AWS CLI profiles for all training accounts."
    echo ""
    
    print_warning "Make sure you have the following information ready:"
    echo "  - AWS Access Key ID and Secret Access Key for each account"
    echo "  - Account IDs for verification"
    echo ""
    
    read -p "Press Enter to continue or Ctrl+C to exit..."
    echo ""
    
    # Check if AWS CLI is installed
    if ! command -v aws &> /dev/null; then
        print_error "AWS CLI is not installed. Please install it first."
        echo "Installation instructions: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
        exit 1
    fi
    
    print_status "Setting up profiles for Team 1 accounts..."
    
    setup_profile "techcorp-team1-master" "Team 1 Control Tower Master Account" ""
    setup_profile "techcorp-team1-existing-prod" "Team 1 Existing Production Account (for legacy resources)" ""
    setup_profile "techcorp-team1-existing-dev" "Team 1 Existing Development Account (for legacy resources)" ""
    
    print_status "Setting up profiles for Team 2 accounts..."
    
    setup_profile "techcorp-team2-master" "Team 2 Control Tower Master Account" ""
    setup_profile "techcorp-team2-existing-prod" "Team 2 Existing Production Account (for legacy resources)" ""
    setup_profile "techcorp-team2-existing-dev" "Team 2 Existing Development Account (for legacy resources)" ""
    
    print_status "Profile setup completed!"
    echo ""
    
    # Verify all profiles
    verify_profiles
    
    echo ""
    print_status "Next steps:"
    echo "  1. Run './deploy-legacy-resources.sh --all' to deploy training resources"
    echo "  2. Verify all accounts are accessible with './setup-aws-profiles.sh --verify'"
    echo "  3. Begin training with students"
    echo ""
    
    print_warning "Security reminders:"
    echo "  - Use temporary credentials that expire within 24 hours"
    echo "  - Monitor account usage and costs during training"
    echo "  - Run cleanup after training: './deploy-legacy-resources.sh --cleanup'"
}

# Main execution
if [[ "$VERIFY_ONLY" == true ]]; then
    verify_profiles
    exit $?
fi

if [[ "$CLEANUP_ONLY" == true ]]; then
    cleanup_profiles
    exit 0
fi

if [[ "$SETUP_ALL" == true ]]; then
    setup_all_profiles
    exit 0
fi

if [[ -n "$PROFILE_NAME" ]]; then
    # Check if AWS CLI is installed
    if ! command -v aws &> /dev/null; then
        print_error "AWS CLI is not installed. Please install it first."
        exit 1
    fi
    
    setup_profile "$PROFILE_NAME" "Custom profile setup" "$EXPECTED_ACCOUNT"
    exit 0
fi

# No arguments provided
print_error "No action specified."
echo ""
usage
exit 1
