# Day 1: Lab Exercises - Fresh Setup of AWS Control Tower

### TechCorp Control Tower Implementation

---

## **📚 Navigation**

**🏠 Home:** [3-Day Training Plan](3-Day-Training-Plan.md) | **📋 Instructor Notes:** [Opening Notes](Instructor-Opening-Notes.md)

**📅 Daily Materials:** [Day 1](Day1-Lab-Exercises.md) | **➡️ Next:** [Day 2](Day2-Lab-Exercises.md)

---

### **Training Structure:**

- **2 Teams:** Team 1 and Team 2 (4 students each)
- **Team Accounts:** Each team will create exactly 4 AWS accounts
- **Team Roles:** Lead, Security Specialist, Network Engineer, Operations Engineer

### **Team Account Structure:**

```
Team 1 Accounts:
├── techcorp-team1-master (Control Tower master)
├── techcorp-team1-log-archive (auto-created by Control Tower)
├── techcorp-team1-audit (auto-created by Control Tower)
├── techcorp-team1-dev (manually created)
└── techcorp-team1-prod (manually created)

Team 2 Accounts:
├── techcorp-team2-master (Control Tower master)
├── techcorp-team2-log-archive (auto-created by Control Tower)
├── techcorp-team2-audit (auto-created by Control Tower)
├── techcorp-team2-dev (manually created)
└── techcorp-team2-prod (manually created)

Existing Accounts (for Day 2):
├── techcorp-team1-existing-prod (pre-populated production)
├── techcorp-team1-existing-dev (pre-populated development)
├── techcorp-team2-existing-prod (pre-populated production)
└── techcorp-team2-existing-dev (pre-populated development)
```

### **Session 1 Lab: Introduction & Architecture Analysis**

#### **Lab 1.1: OU Structure Implementation (30 minutes)**

**Objective:** Create the exact OU structure for TechCorp Control Tower environment

**Required OU Structure:**

```
Root OU
├── Security OU
│   ├── Log Archive Account
│   └── Audit Account
├── Development OU
│   └── Team Dev Account
└── Production OU
    └── Team Prod Account
```

**Team Role Assignments:**

- **Team Lead:** Coordinate all activities, make final decisions, present results
- **Security Specialist:** Configure guardrails, validate compliance, manage IAM policies
- **Network Engineer:** Design VPC CIDR blocks, configure connectivity, manage routing
- **Operations Engineer:** Set up monitoring, configure logging, manage automation

**Required Tasks:**

1. **Create Exact Account Plan:**

   ```
   Team 1 Accounts:
   - Log Archive: techcorp-team1-log-archive@company.com
   - Audit: techcorp-team1-audit@company.com
   - Development: techcorp-team1-dev@company.com
   - Production: techcorp-team1-prod@company.com

   Team 2 Accounts:
   - Log Archive: techcorp-team2-log-archive@company.com
   - Audit: techcorp-team2-audit@company.com
   - Development: techcorp-team2-dev@company.com
   - Production: techcorp-team2-prod@company.com
   ```

2. **Define CIDR Allocations:**

   ```
   Team 1 CIDR Blocks:
   - Development VPC: 10.10.0.0/16
   - Production VPC: 10.11.0.0/16

   Team 2 CIDR Blocks:
   - Development VPC: 10.20.0.0/16
   - Production VPC: 10.21.0.0/16
   ```

3. **Document Guardrails Requirements:**
   - **Security Specialist** will enable these exact guardrails:
     - Disallow internet access for Amazon RDS instances
     - Disallow Amazon EBS volumes that are unencrypted
     - Disallow creation of access keys for root user

**Required Deliverables:**

- OU structure diagram (exactly as specified above)
- Account creation plan with exact email addresses
- CIDR allocation table with no conflicts
- Guardrails implementation checklist

**Cross-Team Coordination (10 minutes):**

- Team 1 presents their plan first (5 minutes)
- Team 2 presents their plan second (5 minutes)
- Instructor validates both plans before proceeding

---

#### **Lab 1.2: Prerequisites Validation (20 minutes)**

**Objective:** Validate all prerequisites are met for Control Tower deployment

**Required Validation Steps:**

1. **AWS Account Access Validation:**

   - **Team Lead:** Log into techcorp-team[X]-master account
   - **Operations Engineer:** Verify billing and cost management access
   - **Security Specialist:** Confirm IAM permissions for Control Tower deployment
   - **Network Engineer:** Validate regional service availability

2. **Service Limits Verification:**

   - **Operations Engineer:** Confirm AWS Organizations service limits allow 4 accounts
   - **Security Specialist:** Verify Control Tower is available in us-east-1
   - **Network Engineer:** Confirm VPC limits support planned CIDR blocks
   - **Team Lead:** Document all limit confirmations

3. **Email Address Preparation:**

   - **Team Lead:** Confirm access to all 4 required email addresses
   - **Operations Engineer:** Verify email addresses are unique across teams
   - **Security Specialist:** Validate email domain access and permissions

4. **Team Communication Setup:**
   - **Team Lead:** Establish shared documentation workspace
   - **All Members:** Exchange contact information
   - **Operations Engineer:** Set up progress tracking method

**Required Deliverables:**

- Completed pre-deployment checklist (all items checked)
- Confirmed email address list (4 addresses per team)
- Service limits validation report (all limits confirmed)
- Team communication procedures document

**Cross-Team Coordination (5 minutes):**

- Teams confirm no CIDR conflicts between Team 1 and Team 2
- Teams verify no email address conflicts
- Instructor approves all prerequisites before Control Tower deployment

---

### **Session 2 Lab: Control Tower Deployment**

#### **Lab 2.1: Control Tower Landing Zone Deployment (45 minutes)**

**Objective:** Deploy AWS Control Tower Landing Zone in the master account

**Prerequisites:**

- Team access to techcorp-team[X]-master account confirmed
- All email addresses validated and accessible
- Prerequisites validation completed and approved

**Required Deployment Steps:**

1. **Access Control Tower Console:**

   - **Team Lead:** Navigate to AWS Control Tower in us-east-1 region
   - **Security Specialist:** Verify all prerequisites are met
   - **Operations Engineer:** Confirm account permissions are sufficient
   - **Network Engineer:** Validate regional service availability

2. **Configure Landing Zone Settings:**

   ```
   Required Configuration:
   - Home Region: us-east-1
   - Additional Regions: us-west-2
   - Log Archive Account Email: techcorp-team[X]-log-archive@company.com
   - Audit Account Email: techcorp-team[X]-audit@company.com
   ```

3. **Create Organizational Units:**

   - **Network Engineer:** Create Security OU
   - **Operations Engineer:** Create Development OU
   - **Security Specialist:** Create Production OU
   - **Team Lead:** Verify all OUs are created correctly

4. **Configure AWS SSO:**
   - **Security Specialist:** Enable AWS SSO in us-east-1
   - **Team Lead:** Create user groups:
     - TechCorp-Team[X]-Developers
     - TechCorp-Team[X]-Operations
     - TechCorp-Team[X]-Security
     - TechCorp-Team[X]-Admins

**Required Results:**

- Landing Zone deployment completed successfully
- Log Archive and Audit accounts created automatically
- 3 OUs created (Security, Development, Production)
- AWS SSO enabled and configured

**Cross-Team Status Check (10 minutes):**

- Team 1 reports deployment status and any issues
- Team 2 reports deployment status and any issues
- Instructor validates both deployments before proceeding

---

#### **Lab 2.2: Account Creation & Guardrails Configuration (30 minutes)**

**Objective:** Create the remaining accounts and configure guardrails

**Required Account Creation:**

1. **Create Development Account:**

   ```
   Team 1:
   Account Name: TechCorp-Team1-Dev
   Email: techcorp-team1-dev@company.com
   OU: Development OU

   Team 2:
   Account Name: TechCorp-Team2-Dev
   Email: techcorp-team2-dev@company.com
   OU: Development OU
   ```

2. **Create Production Account:**

   ```
   Team 1:
   Account Name: TechCorp-Team1-Prod
   Email: techcorp-team1-prod@company.com
   OU: Production OU

   Team 2:
   Account Name: TechCorp-Team2-Prod
   Email: techcorp-team2-prod@company.com
   OU: Production OU
   ```

3. **Configure Mandatory Guardrails:**

   - **Security Specialist:** Verify these guardrails are automatically enabled:
     - Disallow policy changes to log archive
     - Disallow changes to encryption configuration

4. **Enable Required Elective Guardrails:**

   - **Security Specialist:** Enable exactly these guardrails:
     - Disallow internet access for Amazon RDS instances
     - Disallow Amazon EBS volumes that are unencrypted
     - Disallow creation of access keys for root user

5. **Verify Guardrail Status:**
   - **All Team Members:** Check compliance status for all 4 accounts
   - **Security Specialist:** Document guardrail status for each account
   - **Operations Engineer:** Verify no violations exist

**Required Results:**

- 2 additional accounts created (Development and Production)
- Total 5 accounts per team (Master, Log Archive, Audit, Dev, Prod)
- All specified guardrails enabled and compliant
- Zero guardrail violations across all accounts

**Cross-Team Validation (10 minutes):**

- Teams verify account creation success
- Teams confirm guardrail configurations match requirements
- Teams share any challenges encountered and solutions

---

#### **Lab 2.3: SSO Access Configuration (25 minutes)**

**Objective:** Configure user access and permissions through AWS SSO

**Required Permission Sets:**

1. **Create Team Permission Sets:**

   ```
   Team 1 Permission Sets:
   Name: Team1-Developer-Access
   Policies: PowerUserAccess
   Session Duration: 8 hours

   Name: Team1-ReadOnly-Access
   Policies: ReadOnlyAccess
   Session Duration: 4 hours

   Team 2 Permission Sets:
   Name: Team2-Developer-Access
   Policies: PowerUserAccess
   Session Duration: 8 hours

   Name: Team2-ReadOnly-Access
   Policies: ReadOnlyAccess
   Session Duration: 4 hours
   ```

2. **Create Team Users:**

   - **Team Lead:** Add all 4 team members as SSO users
   - **Security Specialist:** Assign users to TechCorp-Team[X]-Developers group
   - **Operations Engineer:** Configure MFA requirements for all users
   - **Network Engineer:** Verify user email addresses are correct

3. **Assign Account Access:**

   - **Security Specialist:** Assign Team[X]-Developer-Access to Development account
   - **Team Lead:** Assign Team[X]-Developer-Access to Production account
   - **Operations Engineer:** Assign Team[X]-ReadOnly-Access to Log Archive account
   - **Network Engineer:** Assign Team[X]-ReadOnly-Access to Audit account

4. **Validate Access:**
   - **Each Team Member:** Test login through SSO portal
   - **Each Team Member:** Verify access to assigned accounts
   - **Security Specialist:** Confirm MFA enforcement works
   - **Team Lead:** Test cross-account access within team environment

**Required Results:**

- 2 permission sets created per team
- 4 SSO users created per team
- Account access assigned correctly
- All team members can access their assigned accounts via SSO

**Cross-Team Access Validation (5 minutes):**

- Teams confirm they cannot access other team's accounts
- Teams verify proper isolation between environments
- Instructor validates SSO configuration for both teams

---

### **Day 1 Final Assessment**

#### **Lab 1.5: Cost Management Implementation (20 minutes)**

**Objective:** Implement cost management and monitoring for the Control Tower environment

**Required Cost Management Setup:**

1. **Enable Cost Allocation Tags:**

   ```
   Required Tags for All Resources:
   - Team: Team1 or Team2
   - Environment: Dev, Prod, Security, Audit
   - Project: TechCorp-ControlTower
   - Owner: [Team Lead Name]
   ```

2. **Configure Billing Alerts:**

   ```
   Required Alert Configuration:
   - Alert Threshold: $50 USD
   - Email Recipient: [Team Lead Email]
   - Alert Name: Team[X]-ControlTower-CostAlert
   - Currency: USD
   - Scope: All team accounts
   ```

3. **Create Cost Dashboard:**

   - **Operations Engineer:** Create CloudWatch dashboard named `Team[X]-Cost-Management`
   - **Team Lead:** Add daily spend by service widget
   - **Security Specialist:** Add monthly spend trend widget
   - **Network Engineer:** Add account-level cost breakdown widget

4. **Apply Cost Tags:**
   - **All Team Members:** Apply required tags to all resources created today
   - **Operations Engineer:** Verify tags appear in billing console within 24 hours
   - **Team Lead:** Test cost filtering by team-specific tags

**Required Results:**

- Cost allocation tags enabled and applied to all resources
- Billing alert configured with $50 threshold
- Cost dashboard created with 3 required widgets
- All team resources properly tagged

---

#### **Lab 1.4: Environment Validation & Documentation (20 minutes)**

**Objective:** Validate complete Day 1 setup and create required documentation

**Required Validation Steps:**

1. **Environment Health Check:**

   - **Operations Engineer:** Verify all 5 team accounts are healthy and accessible
   - **Security Specialist:** Confirm guardrail compliance across all accounts (zero violations)
   - **Network Engineer:** Validate CIDR allocations match specifications
   - **Team Lead:** Confirm SSO access works for all team members

2. **Create Required Documentation:**

   ```
   Required Documents:
   1. Account inventory with exact details and email addresses
   2. OU structure diagram matching implemented configuration
   3. Guardrails status report showing 100% compliance
   4. SSO access matrix with all team member assignments
   5. Cost management configuration summary
   ```

3. **Day 2 Preparation:**

   - **Team Lead:** Confirm access to techcorp-team[X]-existing-prod account
   - **Security Specialist:** Confirm access to techcorp-team[X]-existing-dev account
   - **Operations Engineer:** Document current team configuration baseline
   - **Network Engineer:** Plan integration approach for existing accounts

4. **Knowledge Transfer Documentation:**
   - **Security Specialist:** Document all guardrail decisions and rationale
   - **Network Engineer:** Document CIDR allocation strategy
   - **Operations Engineer:** Document monitoring and cost management setup
   - **Team Lead:** Document team coordination procedures and lessons learned

**Required Results:**

- Complete environment health validation (100% pass rate)
- All 5 required documents created and completed
- Day 2 preparation checklist completed
- Team knowledge transfer documentation completed

**Cross-Team Final Validation (10 minutes):**

- Team 1 confirms 4 accounts operational and compliant
- Team 2 confirms 4 accounts operational and compliant
- Teams verify complete isolation (no cross-team access)
- Instructor validates both teams meet all success criteria

---

### **Troubleshooting Guide for Day 1**

**Issue Resolution Procedures:**

1. **Landing Zone Deployment Failure:**

   - **Team Lead:** Immediately notify instructor
   - **Security Specialist:** Check AWS Organizations prerequisites
   - **Operations Engineer:** Verify account limits and permissions
   - **Network Engineer:** Confirm email addresses are unique and accessible

2. **Account Creation Errors:**

   - **Operations Engineer:** Validate email format matches exact specification
   - **Team Lead:** Verify service limits allow additional accounts
   - **Security Specialist:** Confirm OU exists and is accessible
   - **Network Engineer:** Check for conflicts with other team

3. **SSO Configuration Problems:**

   - **Security Specialist:** Confirm SSO region is us-east-1
   - **Team Lead:** Verify user email domains are accessible
   - **Operations Engineer:** Check permission set policy syntax
   - **Network Engineer:** Validate network connectivity

4. **Guardrail Violations:**
   - **Security Specialist:** Identify specific violation and root cause
   - **Team Lead:** Coordinate immediate remediation
   - **Operations Engineer:** Implement technical fix
   - **Network Engineer:** Verify fix resolves violation

**Escalation Procedure:**

- **Team Lead** escalates all major issues to instructor immediately
- **No troubleshooting beyond 10 minutes** without instructor involvement
- **Document all issues and resolutions** for other teams

**Success Criteria for Day 1:**

- [ ] Landing Zone deployed successfully in master account
- [ ] Exactly 5 accounts created per team (Master, Log Archive, Audit, Dev, Prod)
- [ ] OU structure implemented exactly as specified (Security, Development, Production)
- [ ] SSO configured with all team members having verified access
- [ ] All specified guardrails enabled with zero violations
- [ ] Cost management implemented with $50 alert threshold
- [ ] All required documentation completed
- [ ] Teams ready for Day 2 existing account integration
- [ ] Zero cross-team access (complete isolation verified)
