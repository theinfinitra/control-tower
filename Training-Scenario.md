# AWS Control Tower Training Scenario Overview

## Training Scenario: TechCorp Multi-Account Transformation

### Company Background

TechCorp is a mid-sized technology company undergoing digital transformation. They currently operate multiple standalone AWS accounts with inconsistent governance, security practices, and operational procedures. The company needs to implement enterprise-grade governance using AWS Control Tower while integrating their existing workloads.

## Use Cases & Business Drivers

### Primary Use Cases

1. **Multi-Account Governance Implementation**

   - Centralized security and compliance management
   - Standardized account provisioning and management
   - Automated guardrail enforcement across all environments

2. **Legacy Account Integration**

   - Migrate existing production and development workloads
   - Resolve configuration conflicts with Control Tower requirements
   - Maintain business continuity during transformation

3. **Team-Based Access Management**

   - Role-based access control using AWS SSO
   - Cross-functional team collaboration (Security, Network, Operations)
   - Segregated environments (Development, Production, Audit, Logging)

4. **Operational Excellence**
   - Centralized logging and monitoring
   - Automated compliance reporting
   - Cost management and optimization

## Intentional Conflicts & Violations

### Legacy Production Account Violations

- **Unencrypted RDS databases** (MySQL for Team 1, PostgreSQL for Team 2)
- **Public RDS access** (violates network security guardrails)
- **Unencrypted EBS volumes** on EC2 instances
- **Overpermissive security groups** (SSH from 0.0.0.0/0)
- **IAM roles with PowerUserAccess** (excessive permissions)
- **Public S3 buckets** (data protection violations)
- **Conflicting CloudTrail** named "legacy-prod-trail"

### Legacy Development Account Violations

- **IAM users with access keys** (violates SSO requirements)
- **Unencrypted DynamoDB tables** (encryption guardrail violations)
- **Unencrypted EC2 instances** with development applications
- **AWS Config conflicts** (duplicate configuration recorders)
- **Public S3 bucket access** (mixed access policies)
- **Overpermissive security groups** (development ports open to internet)

### Network Conflicts

- **CIDR overlaps**: Legacy VPCs use conflicting address spaces
  - Team 1: 172.16.0.0/16 (prod), 172.17.0.0/16 (dev)
  - Team 2: 172.26.0.0/16 (prod), 172.27.0.0/16 (dev)

## Control Tower Features Introduction

### Core Control Tower Capabilities

1. **Landing Zone Setup**

   - Automated multi-account environment creation
   - Organizational Unit (OU) structure implementation
   - Foundational accounts (Log Archive, Audit) provisioning

2. **Guardrails (Preventive & Detective)**

   - **Preventive**: Block non-compliant actions (SCPs)
   - **Detective**: Monitor and report violations (Config Rules)
   - **Mandatory**: Cannot be disabled (foundational security)
   - **Strongly Recommended**: Best practices enforcement
   - **Elective**: Optional based on requirements

3. **Account Factory**

   - Standardized account provisioning
   - Automated baseline configuration
   - Custom account templates and resources

4. **AWS SSO Integration**

   - Centralized identity management
   - Role-based access control
   - Multi-account access from single login

5. **Centralized Logging & Monitoring**
   - CloudTrail aggregation in Log Archive account
   - Config data centralization in Audit account
   - Cross-account visibility and compliance reporting

### Key Guardrails Students Will Encounter

**Mandatory Guardrails:**

- Disallow changes to CloudTrail configuration
- Disallow changes to AWS Config configuration
- Disallow changes to Lambda functions in Log Archive account

**Strongly Recommended Guardrails:**

- Disallow public access to S3 buckets
- Disallow unencrypted EBS volumes
- Disallow RDS instances with public access
- Require MFA for root user access

**Elective Guardrails:**

- Disallow specific instance types
- Require encryption for DynamoDB tables
- Disallow internet gateways in specific OUs

## Guardrail Implementation by AWS Service

### Preventive Guardrails

- **AWS Service**: Service Control Policies (SCPs)
- **Mechanism**: JSON policies attached to OUs that explicitly deny specific actions
- **Enforcement**: Real-time blocking at the API level

### Detective Guardrails

- **AWS Service**: AWS Config Rules
- **Mechanism**: Config rules that evaluate resource configurations against compliance standards
- **Enforcement**: Post-deployment monitoring and reporting (does not prevent)

### Proactive Guardrails

- **AWS Service**: CloudFormation Hooks
- **Mechanism**: Pre-deployment validation during CloudFormation stack operations
- **Enforcement**: Blocks non-compliant resources before creation

### Supporting Services

- **AWS Organizations**: Manages multi-account structure and applies SCPs
- **AWS CloudTrail**: Logs API calls for audit and compliance
- **AWS Config**: Tracks resource configuration changes and evaluates compliance
- **AWS Lambda**: Executes custom logic for complex guardrails

## **Guardrail Implementation by Type**

### **Preventive Guardrails**

- **AWS Service**: Service Control Policies (SCPs)
- **Mechanism**: JSON policies attached to OUs that explicitly deny specific
  actions
- **Enforcement**: Real-time blocking at the API level
- **Example**: "Disallow public S3 buckets" uses SCP to deny
  s3:PutBucketPublicAccessBlock with public settings

### **Detective Guardrails**

- **AWS Service**: AWS Config Rules
- **Mechanism**: Config rules that evaluate resource configurations against
  compliance standards
- **Enforcement**: Post-deployment monitoring and reporting (does not prevent)
- **Example**: "Detect unencrypted EBS volumes" uses Config rule
  encrypted-volumes to check EBS encryption status

### **Proactive Guardrails** (newer feature)

- **AWS Service**: CloudFormation Hooks
- **Mechanism**: Pre-deployment validation during CloudFormation stack
  operations
- **Enforcement**: Blocks non-compliant resources before creation
- **Example**: Validates resource configurations in CloudFormation templates
  before deployment

## **Supporting Services**

### **AWS Organizations**

- Manages the multi-account structure
- Applies SCPs to OUs and accounts
- Provides the foundation for guardrail inheritance

### **AWS CloudTrail**

- Logs all API calls for audit and compliance
- Provides data source for detective guardrails
- Centralized in the Log Archive account

### **AWS Config**

- Tracks resource configuration changes
- Evaluates compliance against Config rules
- Stores compliance data in the Audit account

### **AWS Lambda**

- Executes custom logic for complex guardrails
- Processes Config rule evaluations
- Handles remediation actions when configured

## **Example Implementation**

Preventive Guardrail: "Disallow public S3 buckets"

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": ["s3:PutBucketPublicAccessBlock"],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "s3:PublicAccessBlockConfiguration": "false"
        }
      }
    }
  ]
}
```

Detective Guardrail: "Detect unencrypted EBS volumes"

- Uses AWS Config rule: encrypted-volumes
- Evaluates: configuration.encrypted == true
- Reports: Compliant/Non-compliant status
