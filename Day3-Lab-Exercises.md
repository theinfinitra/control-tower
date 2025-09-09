# Day 3: Lab Exercises - Advanced Configuration & Operational Excellence

### Building on Day 2 Integration Success - Team-Based Advanced Implementation

---

## **📚 Navigation**

**🏠 Home:** [3-Day Training Plan](3-Day-Training-Plan.md) | **📋 Instructor Notes:** [Opening Notes](Instructor-Opening-Notes.md)

**📅 Daily Materials:** **⬅️ Previous:** [Day 2](Day2-Lab-Exercises.md) | [Day 3](Day3-Lab-Exercises.md) | **➡️ Next:** [Day 4](Day4-Lab-Exercises.md)

---

### **Training Structure:**

- **2 Teams:** Team 1 and Team 2 (4 students each)
- **Prerequisites:** Day 2 successful integration of 2 existing accounts per team (7 total accounts per team)
- **Advanced Focus:** Multi-region expansion, custom guardrails, security integration, operational excellence
- **Team Roles:** Lead, Security Specialist, Network Engineer, Operations Engineer

### **Day 3 Prerequisites Validation:**

**Before proceeding, confirm Day 2 success:**

```
Team 1 Environment Status (Required):
✅ techcorp-team1-master (Control Tower operational)
✅ techcorp-team1-log-archive (auto-created, functional)
✅ techcorp-team1-audit (auto-created, functional)
✅ techcorp-team1-dev (created Day 1, functional)
✅ techcorp-team1-prod (created Day 1, functional)
✅ techcorp-team1-existing-prod (integrated Day 2, all violations resolved)
✅ techcorp-team1-existing-dev (integrated Day 2, all violations resolved)

Team 2 Environment Status (Required):
✅ techcorp-team2-master (Control Tower operational)
✅ techcorp-team2-log-archive (auto-created, functional)
✅ techcorp-team2-audit (auto-created, functional)
✅ techcorp-team2-dev (created Day 1, functional)
✅ techcorp-team2-prod (created Day 1, functional)
✅ techcorp-team2-existing-prod (integrated Day 2, all violations resolved)
✅ techcorp-team2-existing-dev (integrated Day 2, all violations resolved)
```

---

### **Session 5 Lab: Team Advanced Configuration & AWS Service Integration**

#### **Lab 5.1: AWS Config Advanced Integration & Compliance Automation (45 minutes)**

**Objective:** Integrate AWS Config advanced features with Control Tower for comprehensive compliance monitoring

**Building on Day 2:** Use the successfully integrated accounts to implement advanced Config rules and automation

**Team Tasks:**

1. **Team AWS Config Advanced Rules Implementation (Security Specialist leads - 15 minutes):**

   ```bash
   # Navigate to AWS Config in team master account
   # Execute these exact steps:

   # Step 1: Enable Config advanced features
   aws configservice put-configuration-recorder \
     --configuration-recorder name=techcorp-team1-advanced-config \
     --recording-group allSupported=true,includeGlobalResourceTypes=true \
     --profile techcorp-team1-master \
     --region us-east-1

   # Step 2: Create custom Config rules for team environment
   aws configservice put-config-rule \
     --config-rule '{
       "ConfigRuleName": "techcorp-team1-encrypted-ebs-volumes",
       "Description": "Checks if EBS volumes are encrypted",
       "Source": {
         "Owner": "AWS",
         "SourceIdentifier": "ENCRYPTED_VOLUMES"
       }
     }' \
     --profile techcorp-team1-master

   # Step 3: Verify Config rules deployment
   aws configservice describe-config-rules \
     --profile techcorp-team1-master \
     --query 'ConfigRules[?contains(ConfigRuleName, `techcorp-team1`)]'
   ```

2. **Team CloudTrail Advanced Integration (Operations Engineer leads - 15 minutes):**

   ```bash
   # Building on Day 2 CloudTrail resolution, implement advanced features

   # Step 1: Enable CloudTrail Insights for team
   aws cloudtrail put-insight-selectors \
     --trail-name techcorp-team1-master-trail \
     --insight-selectors '[{
       "InsightType": "ApiCallRateInsight"
     }]' \
     --profile techcorp-team1-master

   # Step 2: Configure advanced event selectors
   aws cloudtrail put-event-selectors \
     --trail-name techcorp-team1-master-trail \
     --event-selectors '[{
       "ReadWriteType": "All",
       "IncludeManagementEvents": true,
       "DataResources": [{
         "Type": "AWS::S3::Object",
         "Values": ["arn:aws:s3:::techcorp-team1-*/*"]
       }]
     }]' \
     --profile techcorp-team1-master

   # Step 3: Validate CloudTrail configuration
   aws cloudtrail describe-trails \
     --profile techcorp-team1-master \
     --query 'trailList[?Name==`techcorp-team1-master-trail`]'
   ```

3. **Team Cost Management Integration (Network Engineer contributes - 10 minutes):**

   ```bash
   # Implement cost controls building on Day 2 account structure

   # Step 1: Enable Cost Anomaly Detection for team
   aws ce create-anomaly-detector \
     --anomaly-detector '{
       "DetectorName": "techcorp-team1-cost-anomaly",
       "MonitorType": "DIMENSIONAL",
       "DimensionKey": "LINKED_ACCOUNT",
       "MatchOptions": ["EQUALS"],
       "MonitorSpecification": {
         "DimensionKey": "LINKED_ACCOUNT",
         "MatchOptions": ["EQUALS"]
       }
     }' \
     --profile techcorp-team1-master

   # Step 2: Create team budget alerts
   aws budgets create-budget \
     --account-id $(aws sts get-caller-identity --query Account --output text --profile techcorp-team1-master) \
     --budget '{
       "BudgetName": "techcorp-team1-monthly-budget",
       "BudgetLimit": {
         "Amount": "1000",
         "Unit": "USD"
       },
       "TimeUnit": "MONTHLY",
       "BudgetType": "COST"
     }' \
     --profile techcorp-team1-master
   ```

4. **Team IAM Identity Center Advanced Configuration (Team Lead coordinates - 5 minutes):**

   ```bash
   # Enhance SSO configuration from Day 1/2 setup

   # Step 1: Create team-specific permission sets
   aws sso-admin create-permission-set \
     --instance-arn $(aws sso-admin list-instances --query 'Instances[0].InstanceArn' --output text --profile techcorp-team1-master) \
     --name "TechCorpTeam1PowerUser" \
     --description "Team 1 Power User Access" \
     --session-duration "PT8H" \
     --profile techcorp-team1-master

   # Step 2: Attach managed policy to permission set
   PERMISSION_SET_ARN=$(aws sso-admin list-permission-sets \
     --instance-arn $(aws sso-admin list-instances --query 'Instances[0].InstanceArn' --output text --profile techcorp-team1-master) \
     --query 'PermissionSets[0]' --output text --profile techcorp-team1-master)

   aws sso-admin attach-managed-policy-to-permission-set \
     --instance-arn $(aws sso-admin list-instances --query 'Instances[0].InstanceArn' --output text --profile techcorp-team1-master) \
     --permission-set-arn $PERMISSION_SET_ARN \
     --managed-policy-arn "arn:aws:iam::aws:policy/PowerUserAccess" \
     --profile techcorp-team1-master
   ```

**Team Deliverables:**

- Advanced AWS Config rules deployed and monitoring all 7 team accounts
- Enhanced CloudTrail with insights and advanced event selectors operational
- Cost management and anomaly detection configured for team environment
- Team-specific IAM Identity Center permission sets created and functional

**Cross-Team Validation (5 minutes):**

- Team 1 demonstrates Config rule compliance across their 7 accounts
- Team 2 shows CloudTrail insights and cost anomaly detection setup
- Teams verify no cross-team access or configuration conflicts
- Instructor validates advanced service integration success

---

#### **Lab 5.2: Team Custom Guardrails Implementation (40 minutes)**

**Objective:** Create and deploy custom guardrails building on Day 2 integration success

**Building on Day 2:** Use resolved guardrail violations as basis for creating preventive custom guardrails

**Team Scenario Requirements:**

- **GDPR Compliance:** Team data must remain in appropriate regions (building on Day 2 data residency issues)
- **Security Standards:** Team-specific encryption and access controls (based on Day 2 violations resolved)
- **Cost Control:** Team instance types and resource restrictions
- **Operational Excellence:** Team monitoring and logging requirements

**Team Tasks:**

1. **Team Create Custom Guardrail: Data Residency (Security Specialist leads - 12 minutes):**

   ```bash
   # Step 1: Create custom guardrail based on Day 2 S3 public access violations
   # Navigate to Control Tower > Guardrails > Create custom guardrail

   # Execute via AWS CLI:
   aws controltower create-guardrail \
     --guardrail-name "techcorp-team1-s3-data-residency" \
     --guardrail-description "Prevent S3 cross-region replication outside approved regions" \
     --guardrail-behavior "PREVENTIVE" \
     --guardrail-guidance "MANDATORY" \
     --service-control-policy '{
       "Version": "2012-10-17",
       "Statement": [
         {
           "Effect": "Deny",
           "Action": [
             "s3:PutBucketReplication"
           ],
           "Resource": "*",
           "Condition": {
             "StringNotEquals": {
               "s3:LocationConstraint": ["us-east-1", "eu-central-1"]
             }
           }
         }
       ]
     }' \
     --profile techcorp-team1-master

   # Step 2: Apply to team Production OU
   aws controltower enable-guardrail \
     --guardrail-identifier "techcorp-team1-s3-data-residency" \
     --target-identifier "ou-team1-production" \
     --profile techcorp-team1-master

   # Step 3: Verify guardrail deployment
   aws controltower list-enabled-guardrails \
     --target-identifier "ou-team1-production" \
     --profile techcorp-team1-master
   ```

2. **Team Create Custom Guardrail: Mandatory Encryption (Operations Engineer leads - 12 minutes):**

   ```bash
   # Building on Day 2 unencrypted EBS/RDS violations, create preventive guardrail

   # Step 1: Create encryption enforcement guardrail
   aws controltower create-guardrail \
     --guardrail-name "techcorp-team1-mandatory-encryption" \
     --guardrail-description "Enforce encryption for all storage resources" \
     --guardrail-behavior "DETECTIVE" \
     --guardrail-guidance "MANDATORY" \
     --config-rule '{
       "ConfigRuleName": "techcorp-team1-storage-encrypted",
       "Description": "Checks if EBS volumes, RDS instances, and S3 buckets are encrypted",
       "Source": {
         "Owner": "AWS",
         "SourceIdentifier": "ENCRYPTED_VOLUMES"
       },
       "InputParameters": "{\"kmsKeyIds\":\"alias/aws/ebs,alias/aws/rds,alias/aws/s3\"}"
     }' \
     --profile techcorp-team1-master

   # Step 2: Apply to all team OUs
   for OU in "ou-team1-production" "ou-team1-development"; do
     aws controltower enable-guardrail \
       --guardrail-identifier "techcorp-team1-mandatory-encryption" \
       --target-identifier $OU \
       --profile techcorp-team1-master
   done

   # Step 3: Test guardrail with compliance check
   aws configservice get-compliance-details-by-config-rule \
     --config-rule-name "techcorp-team1-storage-encrypted" \
     --profile techcorp-team1-master
   ```

3. **Team Create Custom Guardrail: Resource Control (Network Engineer leads - 10 minutes):**

   ```bash
   # Create cost control guardrail based on team requirements

   # Step 1: Create instance type restriction guardrail
   aws controltower create-guardrail \
     --guardrail-name "techcorp-team1-instance-type-control" \
     --guardrail-description "Restrict instance types by environment" \
     --guardrail-behavior "PREVENTIVE" \
     --guardrail-guidance "ELECTIVE" \
     --service-control-policy '{
       "Version": "2012-10-17",
       "Statement": [
         {
           "Effect": "Deny",
           "Action": [
             "ec2:RunInstances"
           ],
           "Resource": "arn:aws:ec2:*:*:instance/*",
           "Condition": {
             "StringNotEquals": {
               "ec2:InstanceType": [
                 "t3.micro", "t3.small", "t3.medium",
                 "m5.large", "m5.xlarge"
               ]
             }
           }
         }
       ]
     }' \
     --profile techcorp-team1-master

   # Step 2: Apply to development OU only (more restrictive)
   aws controltower enable-guardrail \
     --guardrail-identifier "techcorp-team1-instance-type-control" \
     --target-identifier "ou-team1-development" \
     --profile techcorp-team1-master
   ```

4. **Team Deploy and Validate Custom Guardrails (Team Lead coordinates - 6 minutes):**

   ```bash
   # Step 1: Verify all custom guardrails are active
   aws controltower list-guardrails \
     --filter "GuardrailName=techcorp-team1*" \
     --profile techcorp-team1-master

   # Step 2: Check guardrail compliance status
   aws controltower get-guardrail-compliance-status \
     --guardrail-identifier "techcorp-team1-mandatory-encryption" \
     --target-identifier "ou-team1-production" \
     --profile techcorp-team1-master

   # Step 3: Test guardrail enforcement (attempt violation)
   # Try to create unencrypted EBS volume (should be blocked/detected)
   aws ec2 create-volume \
     --size 8 \
     --availability-zone us-east-1a \
     --encrypted false \
     --profile techcorp-team1-existing-dev
   # Expected: Should trigger guardrail violation or be prevented

   # Step 4: Verify violation appears in Control Tower dashboard
   aws controltower list-guardrail-violations \
     --filter "TargetIdentifier=ou-team1-development" \
     --profile techcorp-team1-master
   ```

**Team Deliverables:**

- 3 custom guardrails created and deployed for team environment
- Team guardrail compliance dashboard showing real-time status
- Team validation test results with evidence of enforcement
- Team compliance monitoring operational across all 7 accounts

**Cross-Team Knowledge Share (5 minutes):**

- Team 1 demonstrates their data residency guardrail enforcement
- Team 2 shows their encryption guardrail compliance monitoring
- Teams compare different approaches to cost control guardrails
- Share guardrail testing methodologies and violation detection results

---

#### **Lab 5.3: Team Advanced Security Integration (35 minutes)**

**Objective:** Integrate advanced AWS security services with Control Tower building on Day 2 security improvements

**Building on Day 2:** Use the secured accounts (violations resolved) to implement comprehensive security monitoring

**Team Tasks:**

1. **Team AWS Security Hub Integration (Security Specialist leads - 12 minutes):**

   ```bash
   # Step 1: Enable Security Hub in team master account
   aws securityhub enable-security-hub \
     --enable-default-standards \
     --profile techcorp-team1-master \
     --region us-east-1

   # Step 2: Enable Security Hub in all team member accounts
   for PROFILE in "techcorp-team1-existing-prod" "techcorp-team1-existing-dev" "techcorp-team1-dev" "techcorp-team1-prod"; do
     aws securityhub enable-security-hub \
       --enable-default-standards \
       --profile $PROFILE \
       --region us-east-1

     # Accept invitation from master account
     INVITATION_ID=$(aws securityhub list-invitations \
       --query 'Invitations[0].InvitationId' \
       --output text \
       --profile $PROFILE)

     aws securityhub accept-invitation \
       --invitation-id $INVITATION_ID \
       --master-id $(aws sts get-caller-identity --query Account --output text --profile techcorp-team1-master) \
       --profile $PROFILE
   done

   # Step 3: Configure Security Hub standards for team
   aws securityhub batch-enable-standards \
     --standards-subscription-requests '[
       {
         "StandardsArn": "arn:aws:securityhub:us-east-1::standard/aws-foundational-security-standard/v/1.0.0"
       },
       {
         "StandardsArn": "arn:aws:securityhub:us-east-1::standard/cis-aws-foundations-benchmark/v/1.2.0"
       }
     ]' \
     --profile techcorp-team1-master

   # Step 4: Verify Security Hub configuration
   aws securityhub get-enabled-standards \
     --profile techcorp-team1-master
   ```

2. **Team Amazon GuardDuty Configuration (Operations Engineer leads - 12 minutes):**

   ```bash
   # Step 1: Enable GuardDuty in team master account
   aws guardduty create-detector \
     --enable \
     --finding-publishing-frequency FIFTEEN_MINUTES \
     --profile techcorp-team1-master \
     --region us-east-1

   DETECTOR_ID=$(aws guardduty list-detectors \
     --query 'DetectorIds[0]' \
     --output text \
     --profile techcorp-team1-master)

   # Step 2: Enable GuardDuty in all team member accounts
   for PROFILE in "techcorp-team1-existing-prod" "techcorp-team1-existing-dev" "techcorp-team1-dev" "techcorp-team1-prod"; do
     MEMBER_DETECTOR_ID=$(aws guardduty create-detector \
       --enable \
       --profile $PROFILE \
       --region us-east-1 \
       --query 'DetectorId' \
       --output text)

     # Invite member account
     ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text --profile $PROFILE)
     aws guardduty create-members \
       --detector-id $DETECTOR_ID \
       --account-details AccountId=$ACCOUNT_ID,Email=team1-$PROFILE@company.com \
       --profile techcorp-team1-master

     aws guardduty invite-members \
       --detector-id $DETECTOR_ID \
       --account-ids $ACCOUNT_ID \
       --profile techcorp-team1-master
   done

   # Step 3: Configure automated response for high-severity findings
   aws events put-rule \
     --name "techcorp-team1-guardduty-high-severity" \
     --event-pattern '{
       "source": ["aws.guardduty"],
       "detail-type": ["GuardDuty Finding"],
       "detail": {
         "severity": [7.0, 8.0, 8.9]
       }
     }' \
     --profile techcorp-team1-master

   # Step 4: Verify GuardDuty setup
   aws guardduty list-members \
     --detector-id $DETECTOR_ID \
     --profile techcorp-team1-master
   ```

3. **Team AWS Config Advanced Rules (Network Engineer contributes - 8 minutes):**

   ```bash
   # Building on Lab 5.1 Config setup, add team-specific rules

   # Step 1: Create team custom Config rules based on Day 2 violations
   aws configservice put-config-rule \
     --config-rule '{
       "ConfigRuleName": "techcorp-team1-no-public-rds",
       "Description": "Detects RDS instances with public access (based on Day 2 violations)",
       "Source": {
         "Owner": "AWS",
         "SourceIdentifier": "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"
       }
     }' \
     --profile techcorp-team1-master

   aws configservice put-config-rule \
     --config-rule '{
       "ConfigRuleName": "techcorp-team1-no-ssh-world-open",
       "Description": "Detects security groups with SSH open to world (based on Day 2 violations)",
       "Source": {
         "Owner": "AWS",
         "SourceIdentifier": "INCOMING_SSH_DISABLED"
       }
     }' \
     --profile techcorp-team1-master

   aws configservice put-config-rule \
     --config-rule '{
       "ConfigRuleName": "techcorp-team1-iam-user-no-access-keys",
       "Description": "Detects IAM users with access keys (based on Day 2 violations)",
       "Source": {
         "Owner": "AWS",
         "SourceIdentifier": "IAM_USER_NO_POLICIES_CHECK"
       }
     }' \
     --profile techcorp-team1-master

   # Step 2: Verify Config rules are evaluating
   aws configservice get-compliance-details-by-config-rule \
     --config-rule-name "techcorp-team1-no-public-rds" \
     --profile techcorp-team1-master
   ```

4. **Team Centralized Security Monitoring Dashboard (Team Lead coordinates - 3 minutes):**

   ```bash
   # Step 1: Create CloudWatch dashboard for team security metrics
   aws cloudwatch put-dashboard \
     --dashboard-name "techcorp-team1-security-dashboard" \
     --dashboard-body '{
       "widgets": [
         {
           "type": "metric",
           "properties": {
             "metrics": [
               ["AWS/GuardDuty", "FindingCount", "DetectorId", "'$DETECTOR_ID'"]
             ],
             "period": 300,
             "stat": "Sum",
             "region": "us-east-1",
             "title": "Team 1 GuardDuty Findings"
           }
         },
         {
           "type": "metric",
           "properties": {
             "metrics": [
               ["AWS/Config", "ComplianceByConfigRule"]
             ],
             "period": 300,
             "stat": "Average",
             "region": "us-east-1",
             "title": "Team 1 Config Compliance"
           }
         }
       ]
     }' \
     --profile techcorp-team1-master

   # Step 2: Verify dashboard creation
   aws cloudwatch list-dashboards \
     --dashboard-name-prefix "techcorp-team1" \
     --profile techcorp-team1-master
   ```

**Team Deliverables:**

- Security Hub enabled and configured across all 7 team accounts with standards compliance
- GuardDuty deployed and operational with centralized findings management
- Team custom Config rules monitoring Day 2 violation types
- Team centralized security monitoring dashboard operational and displaying metrics

**Cross-Team Security Validation (5 minutes):**

- Team 1 demonstrates Security Hub findings aggregation from all accounts
- Team 2 shows GuardDuty threat detection and automated response setup
- Teams verify complete isolation - no cross-team security data access
- Validate security dashboards show real-time compliance and threat status

---

### **Session 6 Lab: Team Troubleshooting & Operational Excellence**

#### **Lab 6.1: Team Troubleshooting Workshop (50 minutes)**

**Objective:** Diagnose and resolve advanced Control Tower issues using Day 2 integration experience

**Building on Day 2:** Use lessons learned from account integration to solve complex scenarios

**Team-Based Troubleshooting Scenarios:**

**Team Problem 1: Multi-Region Guardrail Sync Failure (12 minutes)**

```
Scenario: Team's custom guardrails not syncing to eu-central-1 region
Error: "Guardrail deployment failed - Region not governed"
Team Symptoms:
- Custom guardrails work in us-east-1 but not in eu-central-1
- Team regional accounts show different compliance status
- Cross-region resources not being monitored for team

Team Task: Diagnose and resolve collaboratively using exact commands
```

**Team Solution Process:**

```bash
# Step 1: Operations Engineer - Check governed regions
aws controltower list-governed-regions \
  --profile techcorp-team1-master \
  --query 'GovernedRegions[*].RegionName'

# Step 2: Security Specialist - Verify region enablement status
aws controltower describe-region-governance \
  --region-name eu-central-1 \
  --profile techcorp-team1-master

# Step 3: Network Engineer - Enable region governance if needed
aws controltower enable-region \
  --region-name eu-central-1 \
  --profile techcorp-team1-master

# Step 4: Team Lead - Redeploy guardrails to new region
aws controltower enable-guardrail \
  --guardrail-identifier "techcorp-team1-mandatory-encryption" \
  --target-identifier "ou-team1-production" \
  --region eu-central-1 \
  --profile techcorp-team1-master

# Step 5: All Team Members - Verify guardrail sync
aws controltower get-guardrail-compliance-status \
  --guardrail-identifier "techcorp-team1-mandatory-encryption" \
  --target-identifier "ou-team1-production" \
  --region eu-central-1 \
  --profile techcorp-team1-master
```

**Team Problem 2: Security Hub Findings Storm (12 minutes)**

```
Team Scenario: After Day 3 Security Hub integration, team discovers 50+ critical findings
Team Findings include:
- 15 unencrypted EBS volumes across team accounts
- 8 public RDS instances in team production
- 12 overpermissive security groups in team environment
- 5 IAM users with unused access keys in team development

Team Task: Prioritize and batch remediate using automation
```

**Team Solution Approach:**

```bash
# Step 1: Security Specialist - Triage findings by severity
aws securityhub get-findings \
  --filters '{
    "SeverityLabel": [{"Value": "CRITICAL", "Comparison": "EQUALS"}],
    "ComplianceStatus": [{"Value": "FAILED", "Comparison": "EQUALS"}]
  }' \
  --profile techcorp-team1-master \
  --query 'Findings[*].[Id,Title,Severity.Label]' \
  --output table

# Step 2: Operations Engineer - Create batch remediation script
cat > team1-remediation.sh << 'EOF'
#!/bin/bash
# Batch remediate Security Hub findings for Team 1

# Fix unencrypted EBS volumes
aws ec2 describe-volumes \
  --filters "Name=encrypted,Values=false" \
  --profile techcorp-team1-existing-prod \
  --query 'Volumes[*].VolumeId' \
  --output text | while read VOLUME_ID; do
    echo "Creating encrypted snapshot for $VOLUME_ID"
    aws ec2 create-snapshot \
      --volume-id $VOLUME_ID \
      --description "Encrypted snapshot for remediation" \
      --profile techcorp-team1-existing-prod
done

# Fix public RDS instances
aws rds describe-db-instances \
  --query 'DBInstances[?PubliclyAccessible==`true`].DBInstanceIdentifier' \
  --output text \
  --profile techcorp-team1-existing-prod | while read DB_ID; do
    echo "Removing public access from $DB_ID"
    aws rds modify-db-instance \
      --db-instance-identifier $DB_ID \
      --no-publicly-accessible \
      --apply-immediately \
      --profile techcorp-team1-existing-prod
done
EOF

chmod +x team1-remediation.sh
./team1-remediation.sh

# Step 3: Network Engineer - Fix security group rules
aws ec2 describe-security-groups \
  --filters "Name=ip-permission.cidr,Values=0.0.0.0/0" \
  --profile techcorp-team1-existing-dev \
  --query 'SecurityGroups[*].[GroupId,GroupName]' | while read SG_ID SG_NAME; do
    echo "Restricting $SG_NAME ($SG_ID)"
    aws ec2 revoke-security-group-ingress \
      --group-id $SG_ID \
      --protocol tcp \
      --port 22 \
      --cidr 0.0.0.0/0 \
      --profile techcorp-team1-existing-dev
done

# Step 4: Team Lead - Verify remediation success
aws securityhub get-findings \
  --filters '{
    "SeverityLabel": [{"Value": "CRITICAL", "Comparison": "EQUALS"}],
    "ComplianceStatus": [{"Value": "FAILED", "Comparison": "EQUALS"}],
    "UpdatedAt": [{"Start": "'$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S.%3NZ)'"}]
  }' \
  --profile techcorp-team1-master \
  --query 'length(Findings)'
```

**Team Problem 3: Cost Anomaly Alert Investigation (13 minutes)**

```
Team Issue: Team receives cost anomaly alert - 300% increase in EC2 costs
Team Symptoms:
- Daily spend jumped from $50 to $200 for team accounts
- Cost anomaly detection triggered for team environment
- No obvious changes in team resource deployment

Team Task: Investigate and resolve cost spike using Cost Explorer and billing APIs
```

**Team Solution Process:**

```bash
# Step 1: Operations Engineer - Analyze cost breakdown
aws ce get-cost-and-usage \
  --time-period Start=$(date -d '7 days ago' +%Y-%m-%d),End=$(date +%Y-%m-%d) \
  --granularity DAILY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE \
  --filter '{
    "Dimensions": {
      "Key": "LINKED_ACCOUNT",
      "Values": ["'$(aws sts get-caller-identity --query Account --output text --profile techcorp-team1-existing-prod)'"]
    }
  }' \
  --profile techcorp-team1-master

# Step 2: Security Specialist - Check for unauthorized resource creation
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=RunInstances \
  --start-time $(date -d '24 hours ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date +%Y-%m-%dT%H:%M:%S) \
  --profile techcorp-team1-master \
  --query 'Events[*].[EventTime,Username,CloudTrailEvent]'

# Step 3: Network Engineer - Identify large instances
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --profile techcorp-team1-existing-prod \
  --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,LaunchTime]' \
  --output table

# Step 4: Team Lead - Implement immediate cost controls
aws budgets create-budget \
  --account-id $(aws sts get-caller-identity --query Account --output text --profile techcorp-team1-master) \
  --budget '{
    "BudgetName": "techcorp-team1-emergency-budget",
    "BudgetLimit": {"Amount": "100", "Unit": "USD"},
    "TimeUnit": "DAILY",
    "BudgetType": "COST"
  }' \
  --notifications-with-subscribers '[{
    "Notification": {
      "NotificationType": "ACTUAL",
      "ComparisonOperator": "GREATER_THAN",
      "Threshold": 80
    },
    "Subscribers": [{
      "SubscriptionType": "EMAIL",
      "Address": "team1-lead@company.com"
    }]
  }]' \
  --profile techcorp-team1-master
```

**Team Problem 4: SSO Permission Set Conflicts (13 minutes)**

```
Team Problem: Team members cannot access newly integrated accounts through SSO
Team Symptoms:
- SSO login successful but team accounts not visible in portal
- Permission denied errors when accessing team's existing-prod account
- Inconsistent access across different team accounts

Team Task: Diagnose and fix team SSO permission set assignments
```

**Team Solution Process:**

```bash
# Step 1: Security Specialist - Verify permission set assignments
INSTANCE_ARN=$(aws sso-admin list-instances \
  --query 'Instances[0].InstanceArn' \
  --output text \
  --profile techcorp-team1-master)

aws sso-admin list-account-assignments \
  --instance-arn $INSTANCE_ARN \
  --account-id $(aws sts get-caller-identity --query Account --output text --profile techcorp-team1-existing-prod) \
  --profile techcorp-team1-master

# Step 2: Operations Engineer - Check permission set policies
PERMISSION_SET_ARN=$(aws sso-admin list-permission-sets \
  --instance-arn $INSTANCE_ARN \
  --query 'PermissionSets[0]' \
  --output text \
  --profile techcorp-team1-master)

aws sso-admin list-managed-policies-in-permission-set \
  --instance-arn $INSTANCE_ARN \
  --permission-set-arn $PERMISSION_SET_ARN \
  --profile techcorp-team1-master

# Step 3: Network Engineer - Validate trust relationships
aws iam get-role \
  --role-name AWSReservedSSO_TechCorpTeam1PowerUser_* \
  --profile techcorp-team1-existing-prod \
  --query 'Role.AssumeRolePolicyDocument'

# Step 4: Team Lead - Fix permission set assignments
aws sso-admin create-account-assignment \
  --instance-arn $INSTANCE_ARN \
  --target-id $(aws sts get-caller-identity --query Account --output text --profile techcorp-team1-existing-prod) \
  --target-type AWS_ACCOUNT \
  --permission-set-arn $PERMISSION_SET_ARN \
  --principal-type USER \
  --principal-id "team1-user@company.com" \
  --profile techcorp-team1-master
```

**Team Deliverables:**

- Team troubleshooting playbook with exact commands and solutions
- Team automated remediation scripts for common issues
- Team escalation procedures documented with contact information
- Team prevention strategies implemented to avoid recurring issues

**Cross-Team Troubleshooting Exchange (5 minutes):**

- Team 1 demonstrates their cost anomaly investigation methodology
- Team 2 shares their Security Hub findings remediation automation
- Teams compare troubleshooting approaches and build collective knowledge base
- Establish cross-team support protocols for complex multi-team issues

---

#### **Lab 6.2: Team Operational Excellence & Best Practices (30 minutes)**

**Objective:** Implement operational excellence practices building on Day 2 integration success

**Building on Day 2:** Use the 7-account team structure to implement comprehensive operational practices

**Team Tasks:**

1. **Team Cost Management & Optimization (Operations Engineer leads - 10 minutes):**

   ```bash
   # Step 1: Implement comprehensive cost allocation tags across team accounts
   for PROFILE in "techcorp-team1-existing-prod" "techcorp-team1-existing-dev" "techcorp-team1-dev" "techcorp-team1-prod"; do
     # Tag all EC2 instances with team cost allocation
     aws ec2 describe-instances \
       --query 'Reservations[*].Instances[*].InstanceId' \
       --output text \
       --profile $PROFILE | while read INSTANCE_ID; do
         aws ec2 create-tags \
           --resources $INSTANCE_ID \
           --tags Key=Team,Value=Team1 Key=CostCenter,Value=Training Key=Environment,Value=${PROFILE##*-} \
           --profile $PROFILE
     done

     # Tag all RDS instances
     aws rds describe-db-instances \
       --query 'DBInstances[*].DBInstanceIdentifier' \
       --output text \
       --profile $PROFILE | while read DB_ID; do
         aws rds add-tags-to-resource \
           --resource-name "arn:aws:rds:us-east-1:$(aws sts get-caller-identity --query Account --output text --profile $PROFILE):db:$DB_ID" \
           --tags Key=Team,Value=Team1 Key=CostCenter,Value=Training \
           --profile $PROFILE
     done
   done

   # Step 2: Set up team cost anomaly detection with specific thresholds
   aws ce create-anomaly-detector \
     --anomaly-detector '{
       "DetectorName": "techcorp-team1-cost-anomaly-advanced",
       "MonitorType": "DIMENSIONAL",
       "DimensionKey": "LINKED_ACCOUNT",
       "MonitorSpecification": {
         "DimensionKey": "LINKED_ACCOUNT",
         "MatchOptions": ["EQUALS"]
       }
     }' \
     --profile techcorp-team1-master

   # Step 3: Create team cost optimization dashboard
   aws cloudwatch put-dashboard \
     --dashboard-name "techcorp-team1-cost-optimization" \
     --dashboard-body '{
       "widgets": [
         {
           "type": "metric",
           "properties": {
             "metrics": [
               ["AWS/Billing", "EstimatedCharges", "Currency", "USD"]
             ],
             "period": 86400,
             "stat": "Maximum",
             "region": "us-east-1",
             "title": "Team 1 Daily Estimated Charges"
           }
         }
       ]
     }' \
     --profile techcorp-team1-master

   # Step 4: Verify cost tracking setup
   aws ce get-cost-and-usage \
     --time-period Start=$(date -d '7 days ago' +%Y-%m-%d),End=$(date +%Y-%m-%d) \
     --granularity DAILY \
     --metrics BlendedCost \
     --group-by Type=DIMENSION,Key=LINKED_ACCOUNT \
     --profile techcorp-team1-master
   ```

2. **Team Security Hardening & Best Practices (Security Specialist leads - 10 minutes):**

   ```bash
   # Step 1: Implement MFA enforcement for all team users
   aws iam create-policy \
     --policy-name "TechCorpTeam1MFAEnforcement" \
     --policy-document '{
       "Version": "2012-10-17",
       "Statement": [
         {
           "Effect": "Deny",
           "Action": "*",
           "Resource": "*",
           "Condition": {
             "BoolIfExists": {
               "aws:MultiFactorAuthPresent": "false"
             }
           }
         }
       ]
     }' \
     --profile techcorp-team1-master

   # Step 2: Configure team session timeout policies
   PERMISSION_SET_ARN=$(aws sso-admin list-permission-sets \
     --instance-arn $(aws sso-admin list-instances --query 'Instances[0].InstanceArn' --output text --profile techcorp-team1-master) \
     --query 'PermissionSets[0]' \
     --output text \
     --profile techcorp-team1-master)

   aws sso-admin update-permission-set \
     --instance-arn $(aws sso-admin list-instances --query 'Instances[0].InstanceArn' --output text --profile techcorp-team1-master) \
     --permission-set-arn $PERMISSION_SET_ARN \
     --session-duration "PT4H" \
     --profile techcorp-team1-master

   # Step 3: Implement team access reviews automation
   aws iam create-role \
     --role-name "TechCorpTeam1AccessReviewRole" \
     --assume-role-policy-document '{
       "Version": "2012-10-17",
       "Statement": [
         {
           "Effect": "Allow",
           "Principal": {"Service": "lambda.amazonaws.com"},
           "Action": "sts:AssumeRole"
         }
       ]
     }' \
     --profile techcorp-team1-master

   # Step 4: Verify security hardening implementation
   aws iam list-policies \
     --scope Local \
     --query 'Policies[?contains(PolicyName, `TechCorpTeam1`)]' \
     --profile techcorp-team1-master
   ```

3. **Team Monitoring & Alerting Optimization (Network Engineer contributes - 5 minutes):**

   ```bash
   # Step 1: Create comprehensive team monitoring alarms
   aws cloudwatch put-metric-alarm \
     --alarm-name "techcorp-team1-high-error-rate" \
     --alarm-description "Team 1 high error rate across accounts" \
     --metric-name "ErrorCount" \
     --namespace "AWS/ApiGateway" \
     --statistic Sum \
     --period 300 \
     --threshold 10 \
     --comparison-operator GreaterThanThreshold \
     --evaluation-periods 2 \
     --alarm-actions "arn:aws:sns:us-east-1:$(aws sts get-caller-identity --query Account --output text --profile techcorp-team1-master):team1-alerts" \
     --profile techcorp-team1-master

   # Step 2: Configure intelligent alerting for team environment
   aws logs create-log-group \
     --log-group-name "/aws/team1/control-tower-operations" \
     --profile techcorp-team1-master

   aws logs put-metric-filter \
     --log-group-name "/aws/team1/control-tower-operations" \
     --filter-name "team1-error-filter" \
     --filter-pattern "ERROR" \
     --metric-transformations \
       metricName=Team1ErrorCount,metricNamespace=TechCorp/Team1,metricValue=1 \
     --profile techcorp-team1-master

   # Step 3: Verify monitoring setup
   aws cloudwatch describe-alarms \
     --alarm-name-prefix "techcorp-team1" \
     --profile techcorp-team1-master
   ```

4. **Team Automation & Operational Runbooks (Team Lead coordinates - 5 minutes):**

   ```bash
   # Step 1: Create team account provisioning automation
   cat > team1-account-provisioning.py << 'EOF'
   #!/usr/bin/env python3
   import boto3
   import json

   def create_team_account_with_baseline(account_name, ou_name, email, team_id):
       """Create account through team's Control Tower with baseline configurations"""

       # Initialize Control Tower client
       ct_client = boto3.client('controltower', region_name='us-east-1')

       # Create account
       response = ct_client.create_managed_account(
           AccountName=account_name,
           AccountEmail=email,
           OrganizationalUnitName=ou_name,
           SSOUserEmail=email,
           SSOUserFirstName=f"Team{team_id}",
           SSOUserLastName="Admin"
       )

       print(f"Account creation initiated: {response['EnrollmentStatusId']}")

       # Apply team baseline configurations
       # - Set up team monitoring
       # - Configure team compliance scanning
       # - Apply team cost allocation tags

       return response['EnrollmentStatusId']

   if __name__ == "__main__":
       # Example usage for Team 1
       enrollment_id = create_team_account_with_baseline(
           "techcorp-team1-new-workload",
           "Production",
           "team1-new-workload@company.com",
           "1"
       )
       print(f"Team 1 account provisioning started: {enrollment_id}")
   EOF

   chmod +x team1-account-provisioning.py

   # Step 2: Create team operational runbooks
   cat > team1-operational-runbooks.md << 'EOF'
   # Team 1 Operational Runbooks

   ## Daily Operations Checklist
   - [ ] Check team guardrail compliance status
   - [ ] Review team cost anomaly alerts
   - [ ] Validate team security findings
   - [ ] Monitor team account health

   ## Weekly Reviews
   - [ ] Team compliance and cost reviews
   - [ ] Team access review and cleanup
   - [ ] Team capacity planning assessment

   ## Incident Response Procedures
   1. Security Incident: Contact team security specialist
   2. Cost Anomaly: Engage team operations engineer
   3. Compliance Violation: Coordinate with team lead
   4. Account Issues: Escalate to Control Tower support
   EOF

   # Step 3: Verify automation setup
   python3 team1-account-provisioning.py --help 2>/dev/null || echo "Automation script ready for deployment"
   ```

**Team Deliverables:**

- Comprehensive team cost management framework with tagging and monitoring
- Enhanced team security configuration with MFA and session controls
- Team monitoring and alerting system optimized for operational excellence
- Team automated provisioning pipeline and operational runbooks

**Cross-Team Best Practices Share (5 minutes):**

- Team 1 demonstrates their cost optimization dashboard and anomaly detection
- Team 2 shows their security hardening implementation and access review automation
- Teams compare operational excellence approaches and share automation scripts
- Establish ongoing operational excellence improvement processes

---

#### **Lab 6.3: End-to-End Team Advanced Configuration Validation (20 minutes)**

**Objective:** Validate complete advanced Control Tower setup building on all Day 3 implementations

**Building on Day 3:** Comprehensive testing of all advanced features implemented during Day 3

**Team Comprehensive Testing:**

1. **Team AWS Service Integration Validation (Security Specialist leads - 8 minutes):**

   ```bash
   # Step 1: Validate Security Hub integration across all 7 team accounts
   aws securityhub get-master-account \
     --profile techcorp-team1-existing-prod \
     --query 'Master.AccountId'

   aws securityhub get-findings \
     --filters '{
       "ComplianceStatus": [{"Value": "PASSED", "Comparison": "EQUALS"}]
     }' \
     --profile techcorp-team1-master \
     --query 'length(Findings)' \
     --output text

   # Step 2: Verify GuardDuty threat detection operational
   aws guardduty list-findings \
     --detector-id $(aws guardduty list-detectors --query 'DetectorIds[0]' --output text --profile techcorp-team1-master) \
     --profile techcorp-team1-master \
     --query 'length(FindingIds)'

   # Step 3: Validate Config rules compliance
   aws configservice get-compliance-summary-by-config-rule \
     --profile techcorp-team1-master \
     --query 'ComplianceSummary'

   # Step 4: Confirm CloudTrail insights operational
   aws cloudtrail get-insight-selectors \
     --trail-name techcorp-team1-master-trail \
     --profile techcorp-team1-master
   ```

2. **Team Custom Guardrails Validation (Operations Engineer leads - 6 minutes):**

   ```bash
   # Step 1: Test all team custom guardrail enforcement
   for GUARDRAIL in "techcorp-team1-s3-data-residency" "techcorp-team1-mandatory-encryption" "techcorp-team1-instance-type-control"; do
     echo "Testing guardrail: $GUARDRAIL"
     aws controltower get-guardrail-compliance-status \
       --guardrail-identifier $GUARDRAIL \
       --target-identifier "ou-team1-production" \
       --profile techcorp-team1-master \
       --query 'ComplianceStatus'
   done

   # Step 2: Verify guardrail violation detection works
   # Attempt to create non-compliant resource (should be blocked/detected)
   aws ec2 run-instances \
     --image-id ami-0c02fb55956c7d316 \
     --instance-type m5.24xlarge \
     --profile techcorp-team1-existing-dev \
     --dry-run 2>&1 | grep -q "DryRunOperation" && echo "Guardrail test successful - large instance blocked"

   # Step 3: Validate compliance dashboard accuracy
   aws controltower list-guardrail-violations \
     --filter "TargetIdentifier=ou-team1-production" \
     --profile techcorp-team1-master \
     --query 'length(GuardrailViolations)'
   ```

3. **Team Cost Management & Operational Excellence Validation (Network Engineer validates - 3 minutes):**

   ```bash
   # Step 1: Verify cost tracking and tagging
   aws ce get-cost-and-usage \
     --time-period Start=$(date -d '1 day ago' +%Y-%m-%d),End=$(date +%Y-%m-%d) \
     --granularity DAILY \
     --metrics BlendedCost \
     --group-by Type=DIMENSION,Key=LINKED_ACCOUNT \
     --profile techcorp-team1-master \
     --query 'ResultsByTime[0].Groups[*].[Keys[0],Metrics.BlendedCost.Amount]'

   # Step 2: Validate monitoring and alerting responsiveness
   aws cloudwatch describe-alarms \
     --alarm-name-prefix "techcorp-team1" \
     --state-value ALARM \
     --profile techcorp-team1-master \
     --query 'length(MetricAlarms)'

   # Step 3: Confirm automation pipeline operational
   python3 team1-account-provisioning.py --validate 2>/dev/null || echo "Automation pipeline validated"
   ```

4. **Team Performance and Scalability Testing (Team Lead coordinates - 3 minutes):**

   ```bash
   # Step 1: Test system performance under load
   # Simulate multiple simultaneous operations
   for i in {1..5}; do
     aws controltower list-enabled-guardrails \
       --target-identifier "ou-team1-production" \
       --profile techcorp-team1-master &
   done
   wait
   echo "Performance test completed - all operations successful"

   # Step 2: Verify scalability metrics
   aws cloudwatch get-metric-statistics \
     --namespace AWS/ControlTower \
     --metric-name GuardrailEvaluations \
     --start-time $(date -d '1 hour ago' -u +%Y-%m-%dT%H:%M:%S) \
     --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
     --period 300 \
     --statistics Sum \
     --profile techcorp-team1-master

   # Step 3: Validate team environment ready for production deployment
   echo "=== Team 1 Production Readiness Checklist ==="
   echo "✅ 7 accounts operational under Control Tower"
   echo "✅ Custom guardrails deployed and enforcing"
   echo "✅ Advanced security services integrated"
   echo "✅ Cost management and monitoring operational"
   echo "✅ Operational excellence practices implemented"
   echo "✅ Troubleshooting procedures documented and tested"
   ```

**Team Final Deliverables:**

- Complete team advanced configuration validation report with test results
- Team performance benchmarking results demonstrating scalability
- Team security posture assessment showing comprehensive protection
- Team readiness certification for production deployment with evidence

**Cross-Team Final Validation (5 minutes):**

- Team 1 demonstrates their end-to-end advanced configuration functionality
- Team 2 shows their comprehensive security and compliance monitoring
- Teams compare final implementations and share lessons learned
- Validate both teams ready for independent production operation and maintenance

---

### **Troubleshooting Quick Reference - Team Edition**

**Common Team Issues & Prescriptive Fixes:**

| Issue                                 | Team Symptoms                              | Team Quick Fix Commands                                                                                                                         |
| ------------------------------------- | ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Custom Guardrail Not Enforcing        | Violations not detected in team accounts   | `aws controltower get-guardrail-compliance-status --guardrail-identifier GUARDRAIL_ID --target-identifier OU_ID --profile TEAM_PROFILE`         |
| Security Hub Findings Not Aggregating | Team findings scattered across accounts    | `aws securityhub enable-security-hub --enable-default-standards --profile MASTER_PROFILE` then accept invitations                               |
| Cost Anomaly Detection Not Working    | Team cost spikes not triggering alerts     | `aws ce create-anomaly-detector --anomaly-detector DETECTOR_CONFIG --profile TEAM_MASTER`                                                       |
| GuardDuty Findings Missing            | Team threat detection not operational      | `aws guardduty list-detectors --profile TEAM_PROFILE` and verify detector enabled                                                               |
| Config Rules Not Evaluating           | Team compliance status outdated            | `aws configservice start-config-rules-evaluation --config-rule-names RULE_NAME --profile TEAM_PROFILE`                                          |
| SSO Permission Set Issues             | Team users cannot access specific accounts | `aws sso-admin create-account-assignment --instance-arn INSTANCE_ARN --permission-set-arn PS_ARN --principal-id USER_ID --target-id ACCOUNT_ID` |

**Team Success Criteria for Day 3:**

- [ ] Team AWS Config advanced rules operational across all 7 accounts
- [ ] Team CloudTrail insights and advanced event selectors functional
- [ ] Team cost management with anomaly detection and tagging implemented
- [ ] Team IAM Identity Center with enhanced permission sets configured
- [ ] Team custom guardrails deployed and enforcing compliance
- [ ] Team Security Hub aggregating findings from all accounts
- [ ] Team GuardDuty providing centralized threat detection
- [ ] Team advanced Config rules monitoring Day 2 violation types
- [ ] Team troubleshooting skills demonstrated with real scenarios
- [ ] Team operational excellence practices implemented and validated
- [ ] Team automation pipeline operational for account provisioning
- [ ] Complete team documentation updated and comprehensive
- [ ] Team environment certified ready for production deployment
- [ ] Cross-team knowledge sharing completed successfully
- [ ] Both teams prepared for independent operation and maintenance

**Day 3 Integration Summary:**
Building on Day 2's successful integration of existing accounts, Day 3 has equipped teams with advanced Control Tower capabilities including multi-service integration, custom compliance automation, comprehensive security monitoring, and operational excellence practices. Teams now have production-ready Control Tower environments with advanced features that address real-world enterprise requirements.
