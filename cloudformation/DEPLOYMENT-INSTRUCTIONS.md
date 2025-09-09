# Legacy Resources Deployment Instructions
## AWS Control Tower Training - Day 2 Preparation

### Overview
This guide helps you deploy legacy resources into existing AWS accounts before Day 2 Control Tower integration exercises. These resources intentionally create guardrail violations for realistic training scenarios.

---

## Prerequisites

### 1. Required Tools
- **AWS CLI v2** installed and configured
- **Bash shell** (Linux/macOS/WSL)
- **AWS account access** with administrative permissions

### 2. Required Information
- AWS Account IDs for existing accounts
- AWS Access Keys for each account
- Preferred AWS region (default: us-east-1)

### 3. Account Requirements
- **CRITICAL**: Accounts must be **non-Control Tower managed**
- Accounts should not have existing AWS Config setup
- Accounts should not have SCPs that restrict Config operations

---

## Quick Start (For Instructors/Admins)

### Step 1: Setup AWS Profiles
```bash
cd cloudformation/
./setup-aws-profiles.sh --all
```
Follow prompts to configure profiles for all 6 accounts:
- `techcorp-team1-master`
- `techcorp-team1-existing-prod`
- `techcorp-team1-existing-dev`
- `techcorp-team2-master`
- `techcorp-team2-existing-prod`
- `techcorp-team2-existing-dev`

### Step 2: Deploy All Resources
```bash
./deploy-legacy-resources.sh --all
```

### Step 3: Verify Deployment
```bash
./setup-aws-profiles.sh --verify
```

---

## Student Deployment (For Training Participants)

### Simple Deployment Steps

1. **Get your team information from instructor:**
   - Team number (1 or 2)
   - AWS Account IDs (production and development)
   - AWS Access Keys

2. **Setup AWS profiles:**
   ```bash
   cd cloudformation/
   ./setup-aws-profiles.sh --profile team${TEAM_NUMBER}-prod --account YOUR_PROD_ACCOUNT_ID
   ./setup-aws-profiles.sh --profile team${TEAM_NUMBER}-dev --account YOUR_DEV_ACCOUNT_ID
   ```

3. **Deploy resources:**
   ```bash
   # Deploy production resources
   ./deploy-legacy-resources.sh --team ${TEAM_NUMBER} --env prod --profile team${TEAM_NUMBER}-prod
   
   # Deploy development resources
   ./deploy-legacy-resources.sh --team ${TEAM_NUMBER} --env dev --profile team${TEAM_NUMBER}-dev
   ```

4. **Verify deployment:**
   ```bash
   ./setup-aws-profiles.sh --verify
   ```

---

## Advanced Options (For Instructors/Admins)

### Different AWS Region
```bash
# Deploy to us-west-2 instead of us-east-1
./deploy-legacy-resources.sh --team 1 --env prod --profile techcorp-team1-existing-prod --region us-west-2
```

### Custom Profile Names
```bash
# Use your own profile names
./setup-aws-profiles.sh --profile my-prod-account --account 123456789012
./deploy-legacy-resources.sh --team 1 --env prod --profile my-prod-account
```

### Single Account Deployment
```bash
# Deploy only to one specific account
./deploy-legacy-resources.sh --team 1 --env dev --profile techcorp-team1-existing-dev
```

---

## Troubleshooting (For All Users)

### Common Issues

**"Policy does not exist" error:**
- Ensure accounts are not Control Tower managed
- Check that no SCPs are blocking Config operations

**"Stack already exists" error:**
- Script automatically updates existing stacks
- No action needed

**Profile authentication fails:**
```bash
# Re-configure profile
./setup-aws-profiles.sh --profile PROFILE_NAME --account ACCOUNT_ID
```

**Verify account access:**
```bash
aws sts get-caller-identity --profile PROFILE_NAME
```

---

## Resource Summary (For Reference)

**Team 1 Production Account:**
- VPC: 172.16.0.0/16
- RDS: MySQL 8.0.35 (unencrypted, public)
- EC2: 3 instances (unencrypted EBS)
- IAM: 5 roles with PowerUserAccess
- CloudTrail: "legacy-prod-trail"
- S3: Public bucket
- Lambda: Data processor function

**Team 1 Development Account:**
- VPC: 172.17.0.0/16
- EC2: 2 instances with Node.js app
- IAM: 3 users with access keys
- DynamoDB: 2 unencrypted tables
- Config: "legacy-dev-config" recorder
- S3: Mixed access buckets

**Team 2 Production Account:**
- VPC: 172.26.0.0/16
- RDS: PostgreSQL 15.3 (unencrypted, public)
- EC2: 3 instances (unencrypted EBS)
- IAM: 5 roles with PowerUserAccess
- CloudTrail: "legacy-prod-trail"
- S3: Public bucket
- Lambda: Data processor function

**Team 2 Development Account:**
- VPC: 172.27.0.0/16
- EC2: 2 instances with Node.js app
- IAM: 3 users with access keys
- DynamoDB: 2 unencrypted tables
- Config: "legacy-dev-config" recorder
- S3: Mixed access buckets

### Guardrail Violations Created (For Training)
- ❌ Unencrypted EBS volumes
- ❌ Unencrypted RDS databases  
- ❌ RDS with public access
- ❌ S3 buckets with public access
- ❌ IAM users with access keys
- ❌ Overpermissive security groups
- ❌ Unencrypted DynamoDB tables

---

## Cleanup (For All Users)

### Remove All Resources
```bash
./deploy-legacy-resources.sh --cleanup
```

---

## Security Notes

⚠️ **Important:**
- Use temporary AWS credentials (expire within 24 hours)
- These resources intentionally violate security best practices for training
- Run cleanup after training completion
- Do not use in production environments

---

## Next Steps

After successful deployment:
1. ✅ Verify resources are deployed
2. ✅ Begin Day 2 Control Tower integration exercises
3. ✅ Students will identify and resolve conflicts during training
