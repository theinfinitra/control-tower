# Day 2: Lab Exercises - Existing Account Integration

### Control Tower Integration Implementation

---

## **📚 Navigation**

**🏠 Home:** [3-Day Training Plan](3-Day-Training-Plan.md) | **📋 Instructor Notes:** [Opening Notes](Instructor-Opening-Notes.md)

**📅 Daily Materials:** **⬅️ Previous:** [Day 1](Day1-Lab-Exercises.md) | [Day 2](Day2-Lab-Exercises.md) | **➡️ Next:** [Day 3](Day3-Lab-Exercises.md)

---

## **🚨 Prerequisites**

**CRITICAL:** Before starting Day 2 exercises, legacy resources must be deployed to existing accounts.

**📋 Deployment Required:** [Legacy Resources Deployment Instructions](cloudformation/DEPLOYMENT-INSTRUCTIONS.md)

- Instructors/Admins: Use Quick Start section
- Students: Use Student Deployment section
- Accounts must be non-Control Tower managed

---

### **Training Structure:**

- **2 Teams:** Team 1 and Team 2 (4 students each)
- **Integration Target:** Enroll 2 pre-populated existing accounts per team
- **Team Roles:** Lead, Security Specialist, Network Engineer, Operations Engineer

### **Account Structure After Day 2:**

```
Team 1 Complete Environment (7 accounts total):
├── techcorp-team1-master (Control Tower master)
├── techcorp-team1-log-archive (auto-created Day 1)
├── techcorp-team1-audit (auto-created Day 1)
├── techcorp-team1-dev (created Day 1)
├── techcorp-team1-prod (created Day 1)
├── techcorp-team1-existing-prod (integrate today)
└── techcorp-team1-existing-dev (integrate today)

Team 2 Complete Environment (7 accounts total):
├── techcorp-team2-master (Control Tower master)
├── techcorp-team2-log-archive (auto-created Day 1)
├── techcorp-team2-audit (auto-created Day 1)
├── techcorp-team2-dev (created Day 1)
├── techcorp-team2-prod (created Day 1)
├── techcorp-team2-existing-prod (integrate today)
└── techcorp-team2-existing-dev (integrate today)

Optional Account Factory Addition (+1 account per team):
├── techcorp-team1-af-test (Account Factory test - optional)
└── techcorp-team2-af-test (Account Factory test - optional)
```

### **Pre-Populated Existing Account Specifications:**

```
Team 1 Existing Accounts:
├── techcorp-team1-existing-prod
│   ├── VPC: 172.16.0.0/16 (conflicts with standard allocation)
│   ├── RDS: Unencrypted MySQL database with public access
│   ├── EC2: 3 instances with unencrypted EBS volumes
│   ├── S3: Bucket with public read access enabled
│   ├── CloudTrail: "legacy-prod-trail" (conflicts with Control Tower)
│   └── IAM: PowerUserAccess roles (overpermissive)
└── techcorp-team1-existing-dev
    ├── VPC: 172.17.0.0/16 (overlapping subnets)
    ├── Config: "legacy-dev-config" recorder (conflicts with Control Tower)
    ├── IAM: User accounts with access keys (violates SSO)
    ├── DynamoDB: Unencrypted tables
    └── Security Groups: SSH access from 0.0.0.0/0

Team 2 Existing Accounts:
├── techcorp-team2-existing-prod
│   ├── VPC: 172.26.0.0/16 (conflicts with standard allocation)
│   ├── RDS: Unencrypted PostgreSQL database with public access
│   ├── EC2: 3 instances with unencrypted EBS volumes
│   ├── S3: Bucket with public read access enabled
│   ├── CloudTrail: "legacy-prod-trail" (conflicts with Control Tower)
│   └── IAM: PowerUserAccess roles (overpermissive)
└── techcorp-team2-existing-dev
    ├── VPC: 172.27.0.0/16 (overlapping subnets)
    ├── Config: "legacy-dev-config" recorder (conflicts with Control Tower)
    ├── IAM: User accounts with access keys (violates SSO)
    ├── DynamoDB: Unencrypted tables
    └── Security Groups: SSH access from 0.0.0.0/0
```

### **Session 3 Lab: Assessment & Integration Planning**

#### **Lab 3.1: Existing Environment Assessment (40 minutes)**

**Objective:** Complete assessment of pre-populated existing accounts for Control Tower integration

**Required Assessment Tasks:**

1. **Account Inventory Documentation:**

   ```
   Team 1 Required Documentation:
   Account: techcorp-team1-existing-prod
   - VPC CIDR: 172.16.0.0/16
   - RDS Instance: Unencrypted MySQL with public access
   - EC2 Instances: 3 instances with unencrypted EBS
   - S3 Bucket: Public read access enabled
   - CloudTrail: "legacy-prod-trail" active
   - IAM Roles: 5 roles with PowerUserAccess

   Account: techcorp-team1-existing-dev
   - VPC CIDR: 172.17.0.0/16
   - Config Recorder: "legacy-dev-config" active
   - IAM Users: 3 users with access keys
   - DynamoDB Tables: 2 unencrypted tables
   - Security Groups: SSH from 0.0.0.0/0

   Team 2 Required Documentation:
   Account: techcorp-team2-existing-prod
   - VPC CIDR: 172.26.0.0/16
   - RDS Instance: Unencrypted PostgreSQL with public access
   - EC2 Instances: 3 instances with unencrypted EBS
   - S3 Bucket: Public read access enabled
   - CloudTrail: "legacy-prod-trail" active
   - IAM Roles: 5 roles with PowerUserAccess

   Account: techcorp-team2-existing-dev
   - VPC CIDR: 172.27.0.0/16
   - Config Recorder: "legacy-dev-config" active
   - IAM Users: 3 users with access keys
   - DynamoDB Tables: 2 unencrypted tables
   - Security Groups: SSH from 0.0.0.0/0
   ```

2. **Guardrail Conflict Identification:**

   - **Security Specialist:** Document these exact violations:
     - Unencrypted EBS volumes (violates encryption guardrail)
     - RDS with public access (violates network guardrail)
     - S3 public access (violates data protection guardrail)
     - IAM users with access keys (violates SSO requirement)
     - Overpermissive security groups (violates network security)

3. **Service Conflict Documentation:**

   - **Operations Engineer:** Document these exact conflicts:
     - CloudTrail "legacy-prod-trail" (conflicts with Control Tower CloudTrail)
     - Config recorder "legacy-dev-config" (conflicts with Control Tower Config)
     - IAM roles with PowerUserAccess (conflicts with least privilege)

4. **Network Architecture Analysis:**
   - **Network Engineer:** Document these exact network issues:
     - VPC CIDR conflicts with Day 1 allocations
     - Security group rules violating network guardrails
     - Subnet configurations requiring modification

**Required Deliverables:**

- Complete account inventory (exact specifications documented)
- Guardrail violation list (5 violations per account identified)
- Service conflict documentation (CloudTrail, Config, IAM conflicts)
- Network architecture analysis with specific CIDR conflicts

**Cross-Team Validation (10 minutes):**

- Team 1 confirms assessment of their 2 existing accounts
- Team 2 confirms assessment of their 2 existing accounts
- Instructor validates all assessments before proceeding

---

#### **Lab 3.2: Integration Strategy Implementation (30 minutes)**

**Objective:** Create integration strategy for existing account enrollment

**Required Integration Sequence:**

1. **Integration Order (Fixed Sequence):**

   ```
   Phase 1: Development Account Integration (20 minutes)
   - Target: techcorp-team[X]-existing-dev
   - Lead: Operations Engineer
   - Conflicts to resolve: Config recorder, IAM users, DynamoDB encryption

   Phase 2: Production Account Integration (25 minutes)
   - Target: techcorp-team[X]-existing-prod
   - Lead: Team Lead
   - Conflicts to resolve: CloudTrail, RDS encryption, S3 public access
   ```

2. **Conflict Resolution Plan:**

   ```
   Required Resolution Steps:
   Step 1: Disable conflicting CloudTrail "legacy-prod-trail"
   Step 2: Delete Config recorder "legacy-dev-config"
   Step 3: Remove IAM user access keys
   Step 4: Encrypt RDS instances
   Step 5: Remove S3 public access
   Step 6: Modify security group rules
   Step 7: Update IAM role permissions
   ```

3. **Rollback Procedures:**

   ```
   Rollback Triggers:
   - Account enrollment fails after 15 minutes
   - Application functionality breaks
   - Data loss detected
   - Network connectivity lost

   Rollback Actions:
   - Restore CloudTrail configuration
   - Restore Config recorder
   - Restore IAM user access
   - Restore original security groups
   ```

4. **Success Validation Criteria:**
   ```
   Required Validation:
   - Account appears in Control Tower dashboard
   - All guardrails show "Compliant" status
   - SSO access works for all team members
   - Applications respond within 5 seconds
   - Database connectivity maintained
   ```

**Required Deliverables:**

- Integration sequence plan (exact timing and responsibilities)
- Conflict resolution checklist (7 specific steps)
- Rollback procedures (4 triggers, 4 actions)
- Success validation criteria (5 specific checks)

**Cross-Team Coordination (10 minutes):**

- Teams coordinate integration timing (Team 1 starts first)
- Teams share rollback procedures
- Teams establish communication protocol during integration

---

### **Session 4 Lab: Integration Execution**

#### **Lab 4.1: Pre-Integration Preparation (35 minutes)**

**Objective:** Prepare existing accounts for Control Tower enrollment

**Required Preparation Steps:**

1. **Organizations Validation:**

   ```
   Required Checks:
   - Confirm techcorp-team[X]-existing-prod is in AWS Organizations
   - Confirm techcorp-team[X]-existing-dev is in AWS Organizations
   - Verify OrganizationAccountAccessRole exists in both accounts
   - Validate cross-account trust relationships are functional
   ```

2. **Configuration Backup:**

   ```
   Required Backups:
   Team 1:
   - Export CloudTrail "legacy-prod-trail" configuration
   - Export Config recorder "legacy-dev-config" settings
   - Document IAM user access keys before deletion
   - Backup security group rules before modification

   Team 2:
   - Export CloudTrail "legacy-prod-trail" configuration
   - Export Config recorder "legacy-dev-config" settings
   - Document IAM user access keys before deletion
   - Backup security group rules before modification
   ```

3. **Conflict Resolution Preparation:**

   ```
   Required Actions:
   Step 1: Disable CloudTrail "legacy-prod-trail" (do not delete)
   Step 2: Stop Config recorder "legacy-dev-config" (do not delete)
   Step 3: Deactivate IAM user access keys (do not delete users)
   Step 4: Document current RDS and S3 configurations
   ```

4. **Integration Readiness Validation:**
   ```
   Required Validation Checklist:
   - [ ] CloudTrail disabled in existing-prod account
   - [ ] Config recorder stopped in existing-dev account
   - [ ] IAM user access keys deactivated
   - [ ] Application functionality confirmed before integration
   - [ ] Network connectivity tested and documented
   ```

**Required Results:**

- Organizations validation completed (100% pass)
- Configuration backups completed (all 4 items per team)
- Conflict resolution preparation completed (4 steps)
- Integration readiness validation (5 items checked)

**Cross-Team Coordination (10 minutes):**

- Team 1 confirms readiness for integration
- Team 2 confirms readiness for integration
- Teams coordinate integration start times (Team 1 first, Team 2 second)

---

#### **Lab 4.2: Control Tower Integration Execution (45 minutes)**

**Objective:** Execute Control Tower enrollment for existing accounts

**Phase 1: Development Account Integration (20 minutes)**

1. **Enroll Development Account:**

   ```
   Required Steps:
   1. Team Lead: Navigate to Control Tower console
   2. Team Lead: Select "Enroll account"
   3. Team Lead: Enter account ID for techcorp-team[X]-existing-dev
   4. Team Lead: Select "Development OU" as target
   5. Operations Engineer: Monitor enrollment progress
   6. Security Specialist: Watch for guardrail application
   ```

2. **Resolve Integration Conflicts:**

   ```
   Expected Conflicts and Required Resolutions:
   Conflict: Config recorder conflict detected
   Resolution: Confirm recorder was stopped in Lab 4.1

   Conflict: IAM user access key violation
   Resolution: Confirm access keys were deactivated in Lab 4.1

   Conflict: DynamoDB encryption violation
   Resolution: Enable encryption on 2 DynamoDB tables

   Conflict: Security group SSH violation
   Resolution: Modify security group to remove 0.0.0.0/0 SSH access
   ```

3. **Validate Development Integration:**
   ```
   Required Validation Steps:
   - Confirm account appears in Control Tower dashboard
   - Verify all guardrails show "Compliant" status
   - Test SSO access with team credentials
   - Confirm development applications respond within 5 seconds
   - Validate DynamoDB tables are accessible and encrypted
   ```

**Phase 2: Production Account Integration (25 minutes)**

4. **Enroll Production Account:**

   ```
   Required Steps:
   1. Team Lead: Select "Enroll account" in Control Tower console
   2. Team Lead: Enter account ID for techcorp-team[X]-existing-prod
   3. Team Lead: Select "Production OU" as target
   4. All Team Members: Monitor enrollment progress collaboratively
   ```

5. **Resolve Production Conflicts:**

   ```
   Expected Conflicts and Required Resolutions:
   Conflict: CloudTrail conflict detected
   Resolution: Confirm CloudTrail was disabled in Lab 4.1

   Conflict: RDS public access violation
   Resolution: Modify RDS instance to disable public access

   Conflict: RDS encryption violation
   Resolution: Create encrypted snapshot and restore RDS instance

   Conflict: S3 public access violation
   Resolution: Disable S3 bucket public access settings

   Conflict: IAM PowerUserAccess violation
   Resolution: Replace PowerUserAccess with specific permissions
   ```

6. **Validate Production Integration:**
   ```
   Required Validation Steps:
   - Confirm account appears in Control Tower dashboard
   - Verify all guardrails show "Compliant" status
   - Test SSO access for all team members
   - Confirm production applications respond within 5 seconds
   - Validate RDS connectivity and performance
   - Confirm S3 bucket accessibility with new permissions
   ```

**Required Results:**

- 2 accounts enrolled successfully per team
- All guardrail conflicts resolved (zero violations)
- SSO access functional for all team members
- Application response time under 5 seconds
- Database connectivity maintained

**Cross-Team Status Check (10 minutes):**

- Team 1 reports integration results
- Team 2 reports integration results
- Teams share conflict resolution approaches
- Instructor validates both team integrations

---

#### **Lab 4.3: Integration Validation & Testing (30 minutes)**

**Objective:** Validate complete integration success and application functionality

**Required Validation Tests:**

1. **Control Tower Dashboard Validation:**

   ```
   Required Checks:
   - Both existing accounts appear in team's Control Tower dashboard
   - Account status shows "Enrolled" for both accounts
   - All guardrails show "Compliant" status (zero violations)
   - OU assignments correct (existing-dev in Development OU, existing-prod in Production OU)
   ```

2. **SSO Access Validation:**

   ```
   Required Tests (Each Team Member):
   - Log into SSO portal using team credentials
   - Access techcorp-team[X]-existing-dev account
   - Access techcorp-team[X]-existing-prod account
   - Verify appropriate permissions in each account
   - Confirm MFA enforcement works correctly
   ```

3. **Application Functionality Testing:**

   ```
   Required Application Tests:
   Development Account:
   - Test web application responds within 5 seconds
   - Verify DynamoDB read/write operations work
   - Confirm development tools are accessible

   Production Account:
   - Test production application responds within 5 seconds
   - Verify RDS database connectivity and queries
   - Confirm S3 bucket read/write operations work
   - Test monitoring and alerting systems
   ```

4. **Network Connectivity Validation:**

   ```
   Required Network Tests:
   - Ping test between existing accounts and Day 1 accounts
   - Verify VPC peering connections work
   - Test security group rules allow required traffic
   - Confirm DNS resolution works across accounts
   ```

5. **Compliance Status Verification:**
   ```
   Required Compliance Checks:
   - All EBS volumes show encrypted status
   - RDS instances show no public access
   - S3 buckets show no public access
   - IAM users show no active access keys
   - Security groups show no 0.0.0.0/0 SSH access
   ```

**Required Results:**

- Control Tower dashboard shows 7 accounts per team (all enrolled)
- SSO access works for all 4 team members to all accounts
- All applications respond within 5 seconds
- Network connectivity functional between all accounts
- 100% compliance status (zero guardrail violations)

**Cross-Team Final Validation (15 minutes):**

- Team 1 demonstrates successful integration (7 accounts total)
- Team 2 demonstrates successful integration (7 accounts total)
- Teams confirm complete isolation (no cross-team access)
- Instructor validates both teams meet all success criteria

---

### **Day 2 Comprehensive Lab: Account Factory & Final Validation**

#### **Lab 4.5: Account Factory Implementation (30 minutes) - OPTIONAL BUT HIGHLY RECOMMENDED**

**Objective:** Create account using Account Factory automated provisioning (Service Catalog method)

**Prerequisites for This Lab:**

- Core integration (Labs 4.1-4.3) must be completed successfully
- All guardrail violations resolved (100% compliance achieved)
- Team has 15+ minutes remaining in schedule

**Required Account Factory Implementation Steps:**

1. **Access Service Catalog Console:**

   ```
   Step 1: Team Lead navigates to AWS Service Catalog console
   Step 2: Operations Engineer confirms region is us-east-1
   Step 3: Security Specialist verifies team has Service Catalog permissions
   Step 4: Network Engineer confirms console loads without errors
   ```

2. **Locate Account Factory Product:**

   ```
   Step 1: Click "Products" in left navigation menu
   Step 2: Search for "AWS Control Tower Account Factory"
   Step 3: Click on "AWS Control Tower Account Factory" product
   Step 4: Click "Launch Product" button
   ```

3. **Configure Account Factory Parameters:**

   ```
   Required Configuration:

   Team 1 Parameters:
   Product Name: Team1-AccountFactory-Test
   Account Name: TechCorp-Team1-AccountFactory-Test
   Account Email: techcorp-team1-af-test@company.com
   Organizational Unit: Development OU
   SSO User Email: [Team Lead Email]
   SSO User First Name: Team1
   SSO User Last Name: Lead

   Team 2 Parameters:
   Product Name: Team2-AccountFactory-Test
   Account Name: TechCorp-Team2-AccountFactory-Test
   Account Email: techcorp-team2-af-test@company.com
   Organizational Unit: Development OU
   SSO User Email: [Team Lead Email]
   SSO User First Name: Team2
   SSO User Last Name: Lead
   ```

4. **Execute Account Factory Provisioning:**

   ```
   Step 1: Team Lead clicks "Launch Product" button
   Step 2: Operations Engineer monitors "Provisioned Products" page
   Step 3: Security Specialist watches for CloudFormation stack creation
   Step 4: Network Engineer monitors for any error messages
   Step 5: All team members wait for "Available" status (8-10 minutes)
   ```

5. **Validate Account Factory Results:**

   ```
   Required Validation Steps:
   Step 1: Navigate to Control Tower console
   Step 2: Confirm new account appears in account list
   Step 3: Verify account is in Development OU
   Step 4: Check account status shows "Enrolled"
   Step 5: Confirm all guardrails show "Compliant" status
   Step 6: Test SSO access to new account
   ```

6. **Compare Account Creation Methods:**

   ```
   Required Comparison Analysis:

   Manual Account Creation (Day 1):
   - Time Required: 15 minutes per account
   - Steps Required: 8 manual steps
   - Guardrail Application: Manual verification needed
   - Baseline Configuration: Basic Control Tower baseline only
   - Customization: None available

   Account Factory Creation (Today):
   - Time Required: 8 minutes per account (mostly automated)
   - Steps Required: 3 manual steps
   - Guardrail Application: Automatic during provisioning
   - Baseline Configuration: Enhanced baseline with custom resources
   - Customization: Full customization available via templates
   ```

**Required Results (If Lab is Completed):**

- 1 Account Factory test account created per team
- Account provisioning completed within 10 minutes
- Account appears in Control Tower dashboard with "Enrolled" status
- All guardrails show "Compliant" status automatically
- SSO access functional to new account
- Comparison analysis documented

**If Lab is Skipped:**

- Teams proceed directly to Lab 4.4 (Complete Integration Validation)
- Account Factory benefits explained conceptually by instructor
- Teams receive Account Factory reference materials for self-study

**Cross-Team Account Factory Discussion (10 minutes - Only if both teams complete):**

- Team 1 demonstrates Account Factory account (if created)
- Team 2 demonstrates Account Factory account (if created)
- Teams compare automation benefits vs manual Control Tower process
- Teams document Account Factory adoption recommendations for production

**Production Recommendations (Regardless of Lab Completion):**

```
Account Factory Benefits for Production Use:
1. Standardization: Consistent account configurations across organization
2. Automation: Reduced manual effort from 15 minutes to 3 minutes per account
3. Compliance: Automatic guardrail application with zero manual verification
4. Governance: Centralized account management through Service Catalog
5. Customization: Ability to deploy custom baselines and resources
6. Scalability: Support for high-volume account provisioning
7. Auditability: Complete provisioning history through Service Catalog
```

---

#### **Lab 4.4: Complete Integration Validation (30 minutes)**

**Objective:** Validate complete Day 2 integration and prepare for Day 3

**Required Final Validation:**

1. **Complete Environment Health Check:**

   ```
   Required Account Validation:

   If Lab 4.5 was completed (8 accounts per team):
   Team 1 Accounts:
   - [ ] techcorp-team1-master (Control Tower master)
   - [ ] techcorp-team1-log-archive (auto-created)
   - [ ] techcorp-team1-audit (auto-created)
   - [ ] techcorp-team1-dev (created Day 1)
   - [ ] techcorp-team1-prod (created Day 1)
   - [ ] techcorp-team1-existing-prod (integrated today)
   - [ ] techcorp-team1-existing-dev (integrated today)
   - [ ] techcorp-team1-af-test (Account Factory test)

   If Lab 4.5 was skipped (7 accounts per team):
   Team 1 Accounts:
   - [ ] techcorp-team1-master (Control Tower master)
   - [ ] techcorp-team1-log-archive (auto-created)
   - [ ] techcorp-team1-audit (auto-created)
   - [ ] techcorp-team1-dev (created Day 1)
   - [ ] techcorp-team1-prod (created Day 1)
   - [ ] techcorp-team1-existing-prod (integrated today)
   - [ ] techcorp-team1-existing-dev (integrated today)

   Same validation applies to Team 2 accounts
   ```

2. **Guardrail Compliance Verification:**

   ```
   Required Compliance Status (100% for all accounts):
   - All EBS volumes encrypted: 100% compliant
   - No RDS public access: 100% compliant
   - No S3 public access: 100% compliant
   - No IAM user access keys: 100% compliant
   - No overpermissive security groups: 100% compliant
   ```

3. **SSO Access Validation:**

   ```
   Required SSO Tests (All 4 team members):
   - Login success rate: 100%
   - Account access success rate: 100%
   - Permission validation: 100% appropriate access
   - MFA enforcement: 100% functional
   ```

4. **Application Performance Validation:**

   ```
   Required Performance Metrics:
   - Web application response time: <5 seconds
   - Database query response time: <3 seconds
   - S3 object access time: <2 seconds
   - Cross-account connectivity: <1 second latency
   ```

5. **Day 3 Preparation Requirements:**
   ```
   Required Preparation Tasks:
   - Document current account environment baseline (6 or 7 accounts)
   - Identify multi-region expansion requirements
   - Plan custom guardrail implementation needs
   - Prepare advanced security integration requirements
   ```

**Required Results:**

- 7 accounts per team operational and compliant (minimum)
- 8 accounts per team if Account Factory lab completed (bonus)
- 100% guardrail compliance across all accounts
- 100% SSO access success rate for all team members
- All applications meet performance requirements (<5 second response)
- Day 3 preparation checklist completed

**Cross-Team Final Validation (15 minutes):**

- Team 1 confirms account environment operational (7 or 8 accounts)
- Team 2 confirms account environment operational (7 or 8 accounts)
- Teams demonstrate complete environment functionality
- Instructor validates both teams ready for Day 3 advanced configuration

---

### **Troubleshooting Guide for Day 2**

**Issue Resolution Procedures:**

1. **Account Enrollment Failure:**

   ```
   Issue: Account fails to enroll after 15 minutes
   Required Actions:
   - Team Lead: Immediately notify instructor
   - Operations Engineer: Check CloudTrail conflicts
   - Security Specialist: Verify OrganizationAccountAccessRole
   - Network Engineer: Validate account connectivity

   Resolution Steps:
   1. Verify CloudTrail was properly disabled
   2. Confirm Config recorder was stopped
   3. Check IAM role trust relationships
   4. Retry enrollment process
   ```

2. **Guardrail Violations After Integration:**

   ```
   Issue: Guardrails show non-compliant status
   Required Resolution by Violation Type:

   EBS Encryption Violation:
   - Create encrypted snapshots of unencrypted volumes
   - Launch new instances with encrypted volumes
   - Terminate instances with unencrypted volumes

   RDS Public Access Violation:
   - Modify RDS instance to disable public accessibility
   - Update security groups to remove public access
   - Test application connectivity after modification

   S3 Public Access Violation:
   - Disable bucket public access settings
   - Remove public bucket policies
   - Update application IAM roles for bucket access
   ```

3. **Application Functionality Issues:**

   ```
   Issue: Applications stop responding after integration
   Required Diagnosis Steps:
   - Operations Engineer: Check application logs
   - Security Specialist: Verify IAM permissions
   - Network Engineer: Test network connectivity
   - Team Lead: Coordinate rollback if necessary

   Resolution Priority:
   1. Restore critical application functionality
   2. Fix IAM permission issues
   3. Resolve network connectivity problems
   4. Update application configurations
   ```

4. **SSO Access Problems:**
   ```
   Issue: Team members cannot access integrated accounts
   Required Resolution Steps:
   - Security Specialist: Verify permission set assignments
   - Team Lead: Check account enrollment status
   - Operations Engineer: Test SSO portal functionality
   - Network Engineer: Validate network connectivity to SSO
   ```

**Success Criteria for Day 2:**

- [ ] 2 existing accounts integrated successfully per team (mandatory)
- [ ] 1 Account Factory test account created per team (optional but recommended)
- [ ] Minimum 7 accounts operational per team (mandatory)
- [ ] Maximum 8 accounts operational per team (if Account Factory completed)
- [ ] 100% guardrail compliance (zero violations) across all accounts
- [ ] 100% SSO access success rate for all team members
- [ ] All applications respond within 5 seconds
- [ ] Complete environment documentation updated
- [ ] Teams prepared for Day 3 advanced configuration
