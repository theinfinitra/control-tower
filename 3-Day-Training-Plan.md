# AWS Control Tower 3-Day Training Plan

### Complete Materials Index & Focused Delivery Guide for Instructors

---

## **📚 Training Navigation**

**🏠 Home:** [3-Day Training Plan](3-Day-Training-Plan.md) | **📋 Instructor Notes:** [Opening Notes](Instructor-Opening-Notes.md)

**📅 Daily Materials:**

- **Day 1:** [Fresh Control Tower Setup](Day1-Lab-Exercises.md)
- **Day 2:** [Existing Account Integration](Day2-Lab-Exercises.md)
- **Day 3:** [Advanced Configuration](Day3-Lab-Exercises.md)
- **Day 4:** [Reference Material](Day4-Lab-Exercises.md)

---

## **Training Overview**

**Duration:** 3 Days Instructor-Led + 1 Day Reference Material (24 hours total)  
**Format:** Team-based hands-on labs with real-world scenarios  
**Participants:** 8 students organized into 2 teams of 4 students each  
**Scenario:** TechCorp Multi-Account AWS Transformation

### **Team Structure:**

```
Team 1 (4 students):
├── Team Lead (coordination, decisions, presentations)
├── Security Specialist (guardrails, compliance, IAM)
├── Network Engineer (VPC design, connectivity, routing)
└── Operations Engineer (monitoring, logging, automation)

Team 2 (4 students):
├── Team Lead (coordination, decisions, presentations)
├── Security Specialist (guardrails, compliance, IAM)
├── Network Engineer (VPC design, connectivity, routing)
└── Operations Engineer (monitoring, logging, automation)
```

### **AWS Account Structure (6 accounts total):**

```
Team 1 Environment:
├── techcorp-team1-master (Control Tower master)
├── techcorp-team1-existing-prod (pre-populated production)
└── techcorp-team1-existing-dev (pre-populated development)

Team 2 Environment:
├── techcorp-team2-master (Control Tower master)
├── techcorp-team2-existing-prod (pre-populated production)
└── techcorp-team2-existing-dev (pre-populated development)
```

---

## **Pre-Training Setup (1 Day Before)**

### **Instructor Pre-Checks:**

- [ ] **6 AWS accounts** created and accessible
- [ ] **Legacy resources deployed** using CloudFormation templates
- [ ] **AWS CLI profiles** configured and tested
- [ ] **Cost monitoring** enabled on all accounts
- [ ] **Screen sharing/recording** equipment tested
- [ ] **Student materials** printed (backup)
- [ ] **Emergency contacts** and escalation procedures ready

### **Account Validation:**

```bash
# Run verification script
./cloudformation/setup-aws-profiles.sh verify

# Expected: 6 profiles working correctly
# Team 1: master, existing-prod, existing-dev
# Team 2: master, existing-prod, existing-dev
```

### **Cost Baseline:**

- **Expected daily cost per team:** $15-25
- **Alert threshold:** $100 per team (3 days)
- **Monitoring:** Real-time cost dashboards enabled

### **Pre-Population of Existing Accounts:**

```python
# Automated deployment of realistic legacy resources using CloudFormation
# Location: cloudformation/ directory

Templates Created:
1. legacy-production-resources.yaml - Production account with violations
2. legacy-development-resources.yaml - Development account with conflicts
3. deploy-legacy-resources.sh - Automated deployment script
4. setup-aws-profiles.sh - AWS CLI profile configuration

Legacy Resources Deployed:
Production Accounts (Team 1 & 2):
- VPC with CIDR 172.16.0.0/16 (Team 1) or 172.26.0.0/16 (Team 2)
- 3 EC2 instances with unencrypted EBS volumes
- RDS database (MySQL Team 1, PostgreSQL Team 2) with public access
- 5 IAM roles with PowerUserAccess (overpermissive)
- S3 bucket with public access enabled
- CloudTrail "legacy-prod-trail" (conflicts with Control Tower)
- Lambda functions with excessive permissions

Development Accounts (Team 1 & 2):
- VPC with CIDR 172.17.0.0/16 (Team 1) or 172.27.0.0/16 (Team 2)
- 2 EC2 instances with Node.js application
- 3 IAM users with access keys (violation)
- 2 unencrypted DynamoDB tables
- Config recorder "legacy-dev-config" (conflicts with Control Tower)
- S3 buckets with mixed security configurations

Deployment Instructions:
1. Run setup-aws-profiles.sh to configure AWS CLI profiles
2. Run deploy-legacy-resources.sh to deploy all resources
3. Verify deployment with AWS console access
4. Resources will be ready for Day 2 integration exercises
```

---

## **Day 1: Fresh Control Tower Setup**

**Duration:** 8 hours | **Focus:** Foundation and team coordination | **Lab Time:** 6.5 hours | **Theory:** 1.5 hours

### **Pre-Day Checks (30 minutes before):**

- [ ] **Master accounts** clean and accessible
- [ ] **Team credentials** prepared and tested
- [ ] **Cost alerts** configured and active
- [ ] **Presentation materials** ready
- [ ] **Team assignment** materials prepared

### **Session 1: Introduction & Architecture Analysis (4 hours)**

- **Materials:** `Day1-Lab-Exercises.md` (Lab 1.1 - 1.2)
- **Scenario:** Team-based TechCorp fresh setup
- **Key Labs:**
  - Team organizational structure mapping (30 min)
  - Team pre-requisites validation (20 min)
- **Team Deliverables:** Team OU design, account planning, compliance matrix
- **Cross-Team Activities:** Design presentations and coordination

### **Session 2: Team Control Tower Deployment (4 hours)**

- **Materials:** `Day1-Lab-Exercises.md` (Lab 2.1 - 2.4)
- **Key Labs:**
  - Team Landing Zone setup (45 min)
  - Team account creation & guardrails (30 min)
  - Team SSO configuration (25 min)
  - Team basic cost management setup (20 min)
  - Team environment validation (20 min)
- **Team Deliverables:** Working Landing Zone with 3+ accounts per team + cost management
- **Cross-Team Activities:** Progress sharing and troubleshooting support

### **Day 1 Success Criteria:**

- [ ] Both teams have operational Control Tower environments
- [ ] Team coordination and role assignments working effectively
- [ ] Basic cost management and monitoring configured
- [ ] Teams ready for Day 2 integration challenges

---

## **Day 2: Real Account Integration**

**Duration:** 8 hours | **Focus:** Existing account integration | **Lab Time:** 7 hours | **Theory:** 1 hour

### **Pre-Day Checks (15 minutes before):**

- [ ] **Existing accounts** pre-populated and accessible
- [ ] **Legacy resources** deployed and verified
- [ ] **Day 1 environments** still operational
- [ ] **Integration scenarios** prepared

### **Session 3: Assessment & Integration Planning (4 hours)**

- **Materials:** `Day2-Lab-Exercises.md` (Lab 3.1 - 3.2)
- **Scenario:** Team integration of pre-populated existing accounts
- **Key Labs:**
  - Team existing environment discovery (40 min)
  - Team integration planning workshop (30 min)
- **Team Deliverables:** Team assessment matrix, integration strategy
- **Cross-Team Activities:** Knowledge sharing and coordination

### **Session 4: Real Integration Execution (4 hours)**

- **Materials:** `Day2-Lab-Exercises.md` (Lab 4.1 - 4.5)
- **Key Labs:**
  - Team pre-integration preparation (35 min)
  - Team integration execution (45 min)
  - Team advanced scenarios (30 min)
  - Team Account Factory introduction (30 min)
  - Team complete validation (30 min)
- **Team Deliverables:** 2 existing accounts integrated per team + Account Factory experience
- **Cross-Team Activities:** Status updates and mutual support

### **Day 2 Success Criteria:**

- [ ] All existing accounts successfully integrated into Control Tower
- [ ] All guardrail violations resolved without data loss
- [ ] Account Factory workflow understood and tested
- [ ] Teams experienced with real-world integration challenges

---

## **Day 3: Advanced Configuration & Troubleshooting**

**Duration:** 8 hours | **Focus:** Advanced features and operational excellence | **Lab Time:** 7.5 hours | **Theory:** 0.5 hours

### **Pre-Day Checks (15 minutes before):**

- [ ] **Day 2 integrations** completed successfully
- [ ] **Advanced services** enabled in training accounts
- [ ] **Multi-region capabilities** prepared
- [ ] **Troubleshooting scenarios** ready

### **Session 5: Team Advanced Configuration (4 hours)**

- **Materials:** `Day3-Lab-Exercises.md` (Lab 5.1 - 5.3)
- **Scenario:** Team global expansion and advanced security
- **Key Labs:**
  - Team AWS Config advanced integration (45 min)
  - Team custom guardrails implementation (40 min)
  - Team advanced security integration (35 min)
- **Team Deliverables:** Advanced service integration with custom controls per team
- **Cross-Team Activities:** Configuration comparison and knowledge exchange

### **Session 6: Team Troubleshooting & Best Practices (4 hours)**

- **Materials:** `Day3-Lab-Exercises.md` (Lab 6.1 - 6.3)
- **Key Labs:**
  - Team troubleshooting workshop (50 min)
  - Team operational excellence & best practices (30 min)
  - Team advanced configuration validation (20 min)
- **Team Deliverables:** Team troubleshooting playbook, optimized environment + operational procedures
- **Cross-Team Activities:** Best practices sharing and final validation

### **Day 3 Success Criteria:**

- [ ] Advanced AWS service integration operational
- [ ] Custom guardrails deployed and enforcing
- [ ] Comprehensive troubleshooting skills demonstrated
- [ ] Operational excellence practices implemented
- [ ] Teams ready for independent production operation

---

## **Day 4: Reference Material & Next Steps (Self-Paced)**

**Duration:** Self-paced reading | **Format:** Reference documentation

### **Enhanced Content Areas:**

- **Materials:** `Day4-Lab-Exercises.md` (Reference sections)
- **What You've Accomplished:** Summary of 3-day achievements
- **Next Steps for Production:** Implementation roadmap and planning
- **Advanced Topics:** Enhanced self-study materials including:
  - **Account Factory Customization (AFC)** with learning paths
  - **Account Factory for Terraform (AFT)** with code examples
  - **Customizations for Control Tower (CfCT)** implementation guide
  - **Advanced Guardrails Development** with real-world patterns
  - **Operational Excellence** advanced monitoring and cost optimization
  - **Security Automation** at scale with enterprise patterns
- **Certification Pathways:** AWS certification recommendations with Control Tower focus
- **Community Resources:** Enhanced learning resources and official AWS workshops
- **Advanced Project Ideas:** Hands-on projects including enterprise account vending machine
- **Troubleshooting Reference:** Production issue resolution guide with advanced scenarios

---

## **Team Management & Coordination**

### **Team Role Responsibilities:**

#### **Team Lead:**

- Overall team coordination and decision making
- Cross-team communication and collaboration
- Team presentation and knowledge sharing
- Escalation and instructor communication

#### **Security Specialist:**

- Guardrails configuration and compliance
- IAM policies and security controls
- Security monitoring and incident response
- Compliance documentation and validation

#### **Network Engineer:**

- VPC design and network architecture
- Cross-account and cross-region connectivity
- Network security and segmentation
- Performance optimization and troubleshooting

#### **Operations Engineer:**

- Monitoring and alerting configuration
- Automation and operational procedures
- Performance monitoring and optimization
- Backup and recovery procedures

### **Cross-Team Coordination:**

- **Shared Resources:** Coordination to avoid conflicts
- **Knowledge Sharing:** Regular cross-team learning sessions
- **Mutual Support:** Teams assist each other with challenges
- **Best Practices:** Sharing of successful approaches and solutions

---

## **Troubleshooting & Support**

### **Team-Specific Support Structure:**

#### **Internal Team Support:**

- Team members support each other within roles
- Team Lead coordinates internal problem resolution
- Team escalates to instructor when needed

#### **Cross-Team Support:**

- Teams can request assistance from each other
- Shared troubleshooting sessions for common issues
- Cross-team knowledge sharing for solutions

#### **Instructor Support:**

- Available for team escalations and complex issues
- Provides guidance without direct solutions
- Facilitates cross-team coordination when needed

### **Common Team Issues & Solutions:**

1. **Team Coordination Problems:**

   - Clear role definitions and responsibilities
   - Regular team check-ins and communication
   - Shared documentation and decision tracking

2. **Cross-Team Conflicts:**

   - Resource allocation coordination
   - Communication protocols and etiquette
   - Instructor mediation when necessary

3. **Technical Challenges:**
   - Team troubleshooting procedures
   - Cross-team technical support
   - Instructor guidance for complex issues

---

## **Success Metrics & Validation**

### **Training Program Success Metrics:**

- **Technical Competency:** Teams can independently manage Control Tower
- **Collaboration Skills:** Effective team coordination and cross-team support
- **Problem-Solving Ability:** Teams can troubleshoot and resolve issues
- **Knowledge Transfer:** Successful sharing between teams and individuals
- **Production Readiness:** Teams prepared for real-world implementation

### **Final Team Success Criteria:**

- [ ] Both teams successfully deploy Control Tower environments
- [ ] All existing accounts integrated without data loss
- [ ] Advanced configurations implemented and functional
- [ ] Team coordination and collaboration effective
- [ ] Cross-team knowledge sharing successful
- [ ] Documentation complete and comprehensive
- [ ] Teams ready for independent operation

**Training Ready Status:** ✅ All materials updated for team-based structure and validated
