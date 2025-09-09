# AWS Control Tower & Landing Zone Training - Instructor Opening Notes

### 3-Day Training Introduction & Logistics

---

## **📚 Navigation**

**🏠 Home:** [3-Day Training Plan](3-Day-Training-Plan.md) | **📋 Instructor Notes:** [Opening Notes](Instructor-Opening-Notes.md)

**📅 Daily Materials:** **➡️ Start:** [Scenario](Training-Scenario.md) | [Day 1](Day1-Lab-Exercises.md) | [Day 2](Day2-Lab-Exercises.md) | [Day 3](Day3-Lab-Exercises.md) | [Day 4](Day4-Lab-Exercises.md)

---

### **Pre-Training Instructor Checklist (30 minutes before start):**

- [ ] Verify all 6 AWS accounts are accessible and pre-populated
- [ ] Test screen sharing and recording equipment
- [ ] Prepare team assignment materials and name tags
- [ ] Confirm internet connectivity and AWS console access
- [ ] Have emergency contact information ready
- [ ] Prepare backup scenarios for potential issues

---

## **Opening Introduction (15 minutes)**

### **Welcome & Context Setting:**

**"Good morning everyone, and welcome to our 3-day AWS Control Tower and Landing Zone intensive training. I'm [Your Name], and I'll be your instructor for this hands-on journey into enterprise-grade AWS governance.**

**Before we dive in, let me set some important context about what we're going to accomplish together and some critical guidelines we need to follow."**

### **Training Overview:**

**"Over the next 3 days, you'll transform from Control Tower beginners to practitioners who can implement and manage enterprise-scale AWS environments. Here's our journey:"**

- **Day 1:** Fresh Control Tower deployment from scratch
- **Day 2:** Real-world integration of existing AWS accounts
- **Day 3:** Advanced configuration, troubleshooting, and operational excellence
- **Day 4:** Self-paced reference materials for continued learning

**"This isn't just theory - you'll be working with real AWS accounts, deploying actual Control Tower environments, and solving realistic challenges that you'll face in production."**

---

## **Critical Account Usage Guidelines (10 minutes)**

### **⚠️ IMPORTANT ACCOUNT WARNINGS:**

**"Before we touch anything, let me be crystal clear about our AWS account usage. This is CRITICAL for everyone's safety and the success of our training."**

#### **Account Ownership & Responsibility:**

- **"You are working with REAL AWS accounts that incur REAL costs"**
- **"These accounts are provided for training purposes ONLY"**
- **"Any resources you create will be monitored and must be cleaned up"**
- **"Estimated cost per team for 3 days: $20-50 if we follow procedures"**

#### **Strict Usage Rules:**

```
DO:
✅ Follow lab instructions exactly as written
✅ Use only the services and regions specified in labs
✅ Apply cost allocation tags to ALL resources you create
✅ Work within your assigned team accounts ONLY
✅ Ask before deviating from lab procedures

DO NOT:
❌ Create resources outside of lab instructions
❌ Use expensive instance types (stick to t3.micro, t3.small)
❌ Deploy resources in unauthorized regions
❌ Access other teams' accounts
❌ Leave resources running overnight without instructor approval
❌ Share account credentials outside your team
```

#### **Cost Management Responsibility:**

**"Each team will set up cost monitoring on Day 1. If your team exceeds $100 in costs, we'll need to investigate immediately. This is a hard limit for training purposes."**

#### **Account Access Protocol:**

- **"You'll receive temporary credentials that expire daily"**
- **"Credentials will be rotated each morning for security"**
- **"If you lose access, notify me immediately - don't try to troubleshoot alone"**
- **"All account activity is logged and monitored"**

---

## **Team Structure & Logistics (10 minutes)**

### **Team Formation:**

**"We're going to work in 2 teams of 4 people each. This mirrors real-world Control Tower implementations where cross-functional teams collaborate."**

#### **Team Roles & Responsibilities:**

```
Each team will have:
👑 Team Lead - Overall coordination, decisions, presentations
🔒 Security Specialist - Guardrails, compliance, IAM policies
🌐 Network Engineer - VPC design, connectivity, routing
⚙️ Operations Engineer - Monitoring, logging, automation
```

**"Don't worry if you're not an expert in your assigned role - that's the point. You'll learn by doing, and your teammates will help you."**

#### **Team Account Allocation:**

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

### **Collaboration Expectations:**

- **"Teams work independently but share knowledge"**
- **"Help each other, but don't do the work for other teams"**
- **"We'll have regular cross-team sharing sessions"**
- **"Document everything - you'll thank me later"**

---

## **Daily Flow & Expectations (10 minutes)**

### **Daily Schedule Pattern:**

```
Each Day Structure:
09:00-09:15 - Daily standup and credential distribution
09:15-12:30 - Morning session with labs
12:30-13:30 - Lunch break
13:30-17:00 - Afternoon session with labs
17:00-17:15 - Daily wrap-up and environment cleanup
```

### **Learning Approach:**

**"This is hands-on learning with guided discovery. I won't give you all the answers immediately - I'll guide you to find solutions. This builds real problem-solving skills."**

#### **When You Get Stuck:**

1. **Try to solve it with your team first (5 minutes)**
2. **Check with the other team if they've seen the issue**
3. **Raise your hand for instructor help**
4. **Document the solution for others**

#### **Lab Completion Expectations:**

- **"Not every team will finish every lab at the same pace - that's normal"**
- **"Focus on understanding over speed"**
- **"If you fall behind, we'll catch you up - don't panic"**
- **"Quality of learning matters more than completing every step"**

---

## **Technical Environment Overview (5 minutes)**

### **What's Pre-Configured:**

**"To save time and focus on Control Tower concepts, I've pre-configured several things:"**

- **6 AWS accounts** ready for your use
- **Existing 'legacy' accounts** with realistic resources and conflicts
- **Pre-configured IAM access** for each team
- **Monitoring and cost tracking** already enabled

### **What You'll Build:**

- **Fresh Control Tower environments** from scratch
- **Multi-account governance** with guardrails and policies
- **Real account integration** with conflict resolution
- **Advanced security** and compliance controls
- **Operational excellence** procedures and monitoring

### **Tools We'll Use:**

- **AWS Management Console** (primary interface)
- **AWS CLI** (minimal usage, mostly console-based)
- **CloudWatch** for monitoring and dashboards
- **Cost Explorer** for cost management
- **Your laptops** with modern web browsers

---

## **Success Criteria & Assessment (5 minutes)**

### **What Success Looks Like:**

**"By the end of Day 3, each team should have:"**

- ✅ **Functional Control Tower environment** with multiple accounts
- ✅ **Successfully integrated existing accounts** without data loss
- ✅ **Working guardrails and compliance** monitoring
- ✅ **Operational procedures** and troubleshooting skills
- ✅ **Cost management** and optimization practices
- ✅ **Team collaboration** and knowledge sharing abilities

---

## **Safety & Support (5 minutes)**

### **When Things Go Wrong:**

**"In real AWS environments, things break. That's part of learning. Here's how we handle it:"**

#### **Technical Issues:**

- **"Raise your hand immediately - don't struggle alone"**
- **"We have backup procedures for every scenario"**
- **"Account resets are possible if needed"**
- **"Your learning is more important than perfect execution"**

#### **Emergency Procedures:**

- **"If you accidentally create expensive resources, tell me immediately"**
- **"If you lose account access, stop and notify me"**
- **"If you're feeling overwhelmed, that's normal - ask for help"**

#### **Instructor Support:**

- **"I'm here to help, not to judge"**
- **"No question is too basic or too advanced"**
- **"I'd rather you ask 10 times than struggle silently"**

### **Learning Environment:**

**"This is a safe space to make mistakes and learn. Everyone here is learning, including me. We're all in this together."**

---

## **Final Words Before We Start (5 minutes)**

### **Mindset for Success:**

**"Control Tower can seem overwhelming at first - that's normal. We're going to break it down into manageable pieces and build your confidence step by step."**

### **Key Principles:**

- **"Hands-on practice beats theory every time"**
- **"Mistakes are learning opportunities, not failures"**
- **"Collaboration makes everyone stronger"**
- **"Real-world skills matter more than perfect lab execution"**

### **What Makes This Training Different:**

**"Unlike other training, you're working with real accounts, real integration challenges, and real problem-solving. This prepares you for actual Control Tower implementations, not just passing a test."**

---

## **Questions & Team Formation (10 minutes)**

### **Open Floor for Questions:**

**"Before we form teams and start, let's address any questions about:"**

- Account usage and safety
- Training logistics and schedule
- Technical requirements or concerns
- Role expectations and responsibilities

### **Team Formation Process:**

1. **"I'll assign teams to balance experience levels"**
2. **"Each team selects their role assignments"**
3. **"Teams introduce themselves and set working agreements"**
4. **"We'll distribute credentials and verify account access"**

### **Ready to Begin:**

**"Once teams are formed and everyone has confirmed account access, we'll dive into Day 1 Lab 1.1. Remember - this is a journey, not a race. Let's build something amazing together!"**

---

## **Instructor Reminders During Training:**

### **Hourly Check-ins:**

- Monitor team progress and provide guidance
- Watch for cost accumulation in accounts
- Ensure teams are collaborating effectively
- Address technical issues promptly

### **Daily Wrap-ups:**

- Verify resource cleanup completion
- Collect feedback on pace and difficulty
- Preview next day's activities
- Rotate credentials for security

### **Continuous Monitoring:**

- AWS cost dashboards for each team
- Account activity logs for security
- Team dynamics and participation levels
- Technical environment stability

**Remember: Your role is guide and facilitator, not lecturer. Keep students engaged with hands-on activities and real problem-solving.**
