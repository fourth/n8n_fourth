# VIP Guest Intelligence & Personalization Engine
## Comprehensive Demo Scenario for AI Agent Platform Evaluation

---

## **Agent Overview**

**Name:** VIP Guest Intelligence & Personalization Engine

**Purpose:** Proactive guest experience optimization for loyalty program members through intelligent context gathering, multi-agent orchestration, and automated Next Best Actions delivery across multiple channels.

---

## **Trigger**

Real-time webhook from booking system when new reservation created for loyalty program member.

### **Sample Webhook Payload**
```json
{
  "reservation_id": "RES-2025-001234",
  "guest_id": "GUEST-98765",
  "arrival_date": "2025-12-22",
  "party_size": 4,
  "occasion": "Anniversary",
  "special_requests": "Quiet table, vegetarian options"
}
```

**Note:** `loyalty_tier` is NOT included in the webhook payload. It is fetched from CRM in Step 1 (Data Gathering) using the `guest_id`.

---

## **Data Sources** (mocks acceptable for demo)

1. **Customer's Booking System**
   - Reservation details, seating preferences, dietary requirements
   - Past visit frequency, cancellation history

2. **Customer's CRM** (guest profiles, loyalty status)
   - Guest profile: contact info, preferences, VIP notes
   - Lifetime value, loyalty points balance
   - Communication preferences (email/SMS/app)

3. **Review Platforms** (Google, TripAdvisor, OpenTable)
   - Recent reviews written by guest (last 6 months)
   - Sentiment analysis from past feedback
   - Specific mentions (dishes, staff, ambiance)

4. **POS Historical Data** (past orders, preferences)
   - Past orders and spending patterns
   - Favorite dishes, drinks, desserts
   - Average check size and tipping behavior

5. **Fourth iQ** (via Fourth MCP)
   - **Available MCP Tools:**
     - `send_action` - Send actionable items to location managers (displayed on manager phone in iQ App)
       - Actions include a button/link to perform the action in another system
       - Manager reads action, clicks button to open relevant system, performs action, marks as complete
     - `send_alert` - Send informational alerts to managers (acknowledged only, no action button)
       - Alerts are for information only, manager acknowledges but no action required
     - `close_action` - Mark actions as completed from external systems
       - When action is performed in another system, that system calls close_action to mark it complete in Fourth iQ
   - **Note:** Staff schedules, inventory, and table assignments are mocked from other data sources (see Mock Data Setup)
   - **MCP Tool Example (send_action):**
     ```json
     {
       "title": "Review new Barman candidate for London location",
       "synopsis": "There is a new candidate for the Barman position at London location",
       "reason": "The candidate is suitable for the open role Bartender as his previous 3 jobs were exactly as such",
       "message": "Next step: Please open the ATS system and review the candidate's profile to proceed with the next stage of recruitment.",
       "userCanonicalId": "19878984",
       "actionId": "1FA3453",
       "linkTitle": "Review Candidate",
       "linkURL": "https://bla.bla",
       "locationCanonicalId": "984651984654"
     }
     ```

### **Mock Data Setup Recommendations**

For rapid demo setup without connecting to real systems, consider these easy-to-implement mock options:

**Option 1: Google Sheets (Recommended for Quick Setup)**
- **Setup Time:** ~15 minutes
- **Benefits:**
  - No database setup required
  - Easy to edit and share with team
  - Accessible via REST API (Google Sheets API)
  - Can be automated with scripts
  - Visual inspection of data
- **Use Cases:** CRM data, guest profiles, POS historical data, menu items
- **Implementation:** Create separate sheets for each data source, expose via Google Sheets API or simple HTTP endpoints

**Option 2: SQLite Database**
- **Setup Time:** ~30 minutes
- **Benefits:**
  - Version controllable (file-based)
  - Realistic database structure
  - Easy to seed with sample data
  - Can be shared as a file
  - Supports complex queries
- **Use Cases:** Structured data like guest profiles, order history, staff schedules
- **Implementation:** Single SQLite file with tables for guests, reservations, orders, reviews

**Option 3: JSON Files + Simple HTTP Server**
- **Setup Time:** ~10 minutes
- **Benefits:**
  - Simplest setup
  - No external dependencies
  - Easy to modify
  - Can simulate REST API endpoints
- **Use Cases:** Static reference data, simple lookups
- **Implementation:** JSON files served via simple Node.js/Python HTTP server

**Option 4: Platform's Native Database (Fallback)**
- **Benefits:**
  - No external setup needed
  - Integrated with platform
  - Faster for initial testing
- **Drawbacks:**
  - Less realistic (doesn't test external API integration)
  - Platform-specific (harder to reuse across evaluations)
  - May not demonstrate platform's integration capabilities

**Recommendation:** Use **Google Sheets** for CRM and POS data (easy to set up and edit), and **SQLite** for structured historical data. This provides realistic API integration testing while keeping setup minimal. Both can be automated with simple scripts.

**Additional Mock Data Needed:**
- **Staff Schedules:** Create Google Sheet or SQLite table with staff members, ratings, and schedules for demo dates
- **Menu & Inventory:** Create Google Sheet with current menu items, availability status, and dietary information
- **Table Assignments:** Simple JSON file or Google Sheet with table numbers, capacity, location (window/quiet section)

**Note:** These mock data sources simulate what would normally come from other Fourth systems (not available via MCP). The Fourth MCP tools (`send_action`, `send_alert`, `close_action`) are used only for sending actionable items and alerts to managers' mobile devices.

---

## **Multi-Agent Orchestration Architecture**

```
┌─────────────────────────────────────────────────────┐
│  Master Orchestrator: VIP Guest Intelligence Agent  │
│  (Receives booking webhook, coordinates sub-agents) │
└────────────────────┬────────────────────────────────┘
                     │
            ┌────────┴────────┐
            │   Event Bus +   │
            │  Shared Memory  │
            └────────┬────────┘
                     │
            ┌────────▼────────┐
            │  Decision &     │
            │  Recommendation │
            │  Synthesis Agent│
            │  (Steps 1-3)    │
            └────────┬────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
┌───────▼────────┐ ┌─▼────────────────┐ ┌─▼─────────────────┐
│ Fourth iQ      │ │ Staff Briefing   │ │ Guest Comms       │
│ Action Agent   │ │ Agent            │ │ Agent             │
│                │ │                  │ │                   │
│ - Create VIP   │ │ - Generate       │ │ - Send pre-visit  │
│   task for     │ │   personalized   │ │   email with      │
│   manager      │ │   briefing       │ │   menu preview    │
│ - Update guest │ │   document       │ │ - Send 24h        │
│   profile      │ │                  │ │   reminder email  │
└────────────────┘ └──────────────────┘ └───────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼────────┐      ┌────────▼────────┐
│ Guest Reminder │      │ Profile Update │
│ Agent          │      │ Agent          │
│                │      │                │
│ - Send 24h     │      │ - Update guest │
│   before email │      │   profile with │
│   with parking │      │   latest       │
│   details      │      │   preferences  │
└────────────────┘      └────────────────┘
```

---

## **Decision Logic Flow**

### **Step 1: Pull Knowledge Base and Other Data** (RAG or Structured)

**Data Sources:**
- **Brand service standards and VIP protocols** (from knowledge base/RAG)
  - Example: "Gold members receive complimentary welcome drink"
  - Example: "Anniversary celebrations include special dessert presentation"
  
- **Historical guest visit patterns and preferences** (from CRM/RAG)
  - Past visit notes: "Prefers window seating, allergic to shellfish"
  - Visit frequency: 12 prior visits over 18 months
  - Average spend: $185 per visit
  
- **Past order history and favorite menu items** (from POS data)
  - Order history: "Always orders Pinot Noir, likes medium-rare steak"
  - Favorite dishes: ["Truffle Risotto", "Ribeye 14oz", "Chocolate Soufflé"]
  - Dietary restrictions: Shellfish allergy
  
- **Similar guest profiles for recommendation patterns** (from RAG/vector similarity)
  - Collaborative filtering: "Guests with similar preferences also enjoyed..."
  - Cross-reference with current menu availability

**Output to Shared Memory:**
```json
{
  "guest_profile": {
    "lifetime_visits": 12,
    "avg_spend": 185,
    "loyalty_tier": "Gold",
    "preferences": {
      "seating": "window",
      "allergies": ["shellfish"],
      "favorites": ["Pinot Noir", "ribeye steak", "truffle dishes"]
    }
  },
  "brand_protocols": {
    "gold_member_benefits": ["complimentary_welcome_drink"],
    "anniversary_treatment": ["special_dessert", "acknowledgment"]
  }
}
```

---

### **Step 2: Context Analysis**

**Analysis Tasks:**
- **Conduct sentiment analysis over recent reviews written by guest**
  - Web search/API: Recent reviews on Google, TripAdvisor, OpenTable (last 6 months)
  - LLM Analysis: Extract sentiment and specific mentions
    - Latest review (2 months ago): "Service was excellent, loved the truffle pasta"
    - Previous review: "Noise level was a bit high, but food outstanding"
  
- **Cross-reference with reservation details and loyalty tier**
  - Current reservation: Anniversary, party of 4, arrival Dec 22
  - Loyalty tier: Gold (high priority)
  - Special requests: "Quiet table, vegetarian options"
  
- **Identify specific preferences** (seating, dietary, favorite dishes)
  - Seating: Window preference + noise concern from past review
  - Dietary: Shellfish allergy (critical), vegetarian options needed
  - Favorite dishes: Truffle pasta (mentioned in review), ribeye steak (order history)
  
- **Analyze past feedback for service improvement opportunities**
  - Positive: Service quality, food quality, truffle dishes
  - Concern: Noise level (addressable with table selection)
  - Trend: Increasingly positive sentiment over time

**Output to Shared Memory:**
```json
{
  "sentiment_analysis": {
    "overall_sentiment": 8.5,
    "positive_mentions": ["service", "truffle pasta", "food quality"],
    "concerns": ["noise level"],
    "trending": "increasingly positive"
  },
  "reservation_context": {
    "occasion": "Anniversary",
    "party_size": 4,
    "special_requests": ["quiet table", "vegetarian options"]
  },
  "preferences_identified": {
    "seating": "window, quiet section",
    "dietary": ["shellfish allergy", "vegetarian options"],
    "favorites": ["truffle dishes", "ribeye steak", "Pinot Noir"]
  }
}
```

---

### **Step 3: Multi-Step Reasoning**

**Reasoning Process:**

1. **Classify guest priority level** (loyalty tier + occasion + visit frequency)
   - Input: Gold tier + Anniversary + 12 visits
   - Output: Priority Level = **VIP-High**
   - Rationale: High-value guest with special occasion

2. **Determine optimal table assignment** based on preferences and past concerns
   - Input: Window preference + noise concern from review
   - Reasoning: Need window table in quieter section
   - Output: **Table 12** (window, quieter section, accommodates 4)

3. **Match available menu items** with guest preferences and dietary needs
   - **Mock Data Source:** Query mock menu/inventory API (Google Sheets or SQLite)
   - Cross-reference: Guest favorites vs. available items from mock data
   - Dietary check: Ensure no shellfish, include vegetarian options
   - Output: 
     - Recommended: Truffle Risotto (in stock, matches preference)
     - Alternative: Ribeye 14oz (in stock, favorite)
     - Wine pairing: Pinot Noir or similar profile

4. **Identify appropriate staff assignment** (best-rated server available)
   - **Mock Data Source:** Query mock staff schedule API (Google Sheets or SQLite)
   - Filter: Top-rated servers (rating > 4.5) from mock staff database
   - Check availability: Is Sarah (server #247, 4.9 rating) scheduled?
   - Output: **Assign server Sarah** (or alternative if unavailable)

5. **Recommend personalized touches** (complimentary items, special preparations)
   - Brand protocol: Gold member = complimentary welcome drink
   - Occasion: Anniversary = special dessert presentation
   - Surprise factor: Complimentary champagne on arrival
   - Kitchen prep: Pre-notify chef of shellfish allergy

**Output: Next Best Actions Bundle**
```json
{
  "priority_level": "VIP-High",
  "table_assignment": "Table 12 (window, quieter section)",
  "staff_assignment": "Server Sarah (4.9 rating)",
  "menu_recommendations": [
    {"item": "Truffle Risotto", "confidence": 0.95, "in_stock": true},
    {"item": "Ribeye 14oz", "confidence": 0.90, "in_stock": true}
  ],
  "wine_pairing": "Pinot Noir",
  "personalized_touches": [
    "Complimentary champagne on arrival",
    "Special anniversary dessert presentation",
    "Kitchen alert: shellfish allergy"
  ],
  "recommended_actions": [
    {
      "action": "reserve_table",
      "details": "Table 12 (window, quieter section)",
      "timing": "immediate"
    },
    {
      "action": "staff_assignment",
      "details": "Assign server Sarah, brief on guest history",
      "timing": "day_of_arrival"
    },
    {
      "action": "kitchen_prep",
      "details": "Pre-notify chef of shellfish allergy",
      "timing": "day_of_arrival"
    },
    {
      "action": "guest_communication",
      "details": "Send personalized welcome email",
      "timing": "immediate"
    },
    {
      "action": "surprise_delight",
      "details": "Complimentary champagne + dessert",
      "timing": "during_service"
    }
  ]
}
```

---

### **Step 4: Actions** (Parallel Execution via Specialized Agents)

#### **Agent 1: Fourth iQ Action Agent** (via Fourth MCP)

**Action:** Send actionable VIP task to manager in Fourth iQ using `send_action` tool

**MCP Tool Call:** `send_action`

**Action Payload:**
```json
{
  "title": "VIP Guest Arrival - Gold Member Anniversary",
  "synopsis": "VIP guest John & Maria Smith (Gold loyalty) arriving Dec 22, 7:30 PM for anniversary celebration. Party of 4.",
  "reason": "Gold tier loyalty member with 12 prior visits. Anniversary occasion requires special attention. Guest has shellfish allergy and prefers quiet seating.",
  "message": "Next steps: Reserve Table 12 (window, quieter section), assign server Sarah, prep complimentary champagne and anniversary dessert plate. Kitchen alert: shellfish allergy. Review full guest briefing document for detailed service recommendations.",
  "userCanonicalId": "19878984",
  "actionId": "VIP-RES-2025-001234",
  "linkTitle": "View Guest Briefing",
  "linkURL": "https://crm.example.com/guests/GUEST-98765/briefing/RES-2025-001234",
  "locationCanonicalId": "984651984654"
}
```

**Note:** Staff schedule check uses mock data (not Fourth MCP). The action directs the manager to review the briefing document which contains staff assignment recommendations based on mock schedule data.

---

#### **Agent 2: Staff Briefing Agent**

**Action:** Generate staff briefing document and send informational alert via Fourth MCP

**Briefing Document:**
```markdown
## VIP Guest Briefing - RES-2025-001234

**Guest:** John & Maria Smith (Gold Loyalty)
**Occasion:** Anniversary
**Arrival:** Dec 22, 7:30 PM, Party of 4

**Key Intel:**
- 12 prior visits, always positive experience
- Recent review praised truffle pasta
- Prefers quiet ambiance (note: noise concern in past)
- CRITICAL: Shellfish allergy

**Recommendations:**
- Suggest: Truffle Risotto, Ribeye, Pinot Noir
- Table: 12 (window, quieter section)
- Surprise: Complimentary champagne on arrival

**Service Notes:**
- Warm greeting by name
- Acknowledge anniversary early in service
- Check in after appetizers (quality control)
- Ensure vegetarian options available
```

**MCP Tool Call:** `send_alert` (informational alert for staff awareness)

**Alert Payload:**
```json
{
  "title": "VIP Guest Briefing Available - RES-2025-001234",
  "synopsis": "Detailed briefing document available for VIP guest John & Maria Smith arriving Dec 22, 7:30 PM",
  "reason": "Gold tier loyalty member, anniversary celebration. Briefing contains guest preferences, dietary restrictions, and service recommendations.",
  "message": "Review briefing document for complete guest intelligence and service recommendations.",
  "userCanonicalId": "19878984",
  "locationCanonicalId": "984651984654"
}
```

**Additional Delivery:** Email briefing document to assigned server (Sarah) if email address available from mock staff database

---

#### **Agent 3: Guest Communications Agent (Pre-Visit Email)**

**Action:** Send personalized pre-visit email with menu previews and confirmations

**Email Content:**
```
Subject: We're excited to welcome you back, John!

Dear John & Maria,

Congratulations on your anniversary! We're thrilled you've chosen 
to celebrate with us on December 22nd.

Based on your preferences, we've reserved our best window table 
for you. Chef has prepared a special menu featuring your favorites, 
including our signature truffle risotto.

We've noted your dietary requirements and have everything ready 
for a memorable evening.

See you soon!
[Restaurant Team]
```

**Timing:** Immediate (upon reservation)

---

#### **Agent 4: Guest Reminder Agent**

**Action:** Send email reminder with parking/arrival details 24h before visit

**Email Content:**
```
Subject: Reminder: Your reservation tomorrow at 7:30 PM

Hi John!

Looking forward to your visit tomorrow at 7:30 PM. 
Your favorite table is ready.

**Arrival Details:**
- Time: 7:30 PM
- Table: Window table (quieter section)
- Parking: Available on Oak St. (complimentary valet)

See you soon!
[Restaurant Name]
```

**Timing:** 24 hours before arrival (automated scheduling)

---

#### **Agent 5: Profile Update Agent**

**Action:** Update guest profile with latest preferences and notes

**Profile Updates:**
```
Guest Profile Update (via Mock CRM API - Google Sheets or SQLite):
- Flag: "VIP - Personalized Service Active"
- Notes: "Loves truffle dishes, prefers quiet seating"
- Preferences: "Window table, Pinot Noir"
- Latest visit: 2025-12-22 (Anniversary)
- Service notes: "Complimentary champagne provided, positive response"
```

**Note:** Profile updates use mock CRM data source (not Fourth MCP). After visit completion, external system can call `close_action` with the actionId to mark the VIP action as completed in Fourth iQ.

**MCP Tool Call (after visit):** `close_action`
```json
{
  "actionId": "VIP-RES-2025-001234",
  "locationCanonicalId": "984651984654"
}
```

**Timing:** After visit completion (or immediate for preference updates)

---

## **Advanced Demo Features to Showcase**

### **1. Agent-to-Agent Communication via Event Bus**

**Scenario to Demo:**
```
1. Preference Matching Agent discovers: "Truffle risotto is 86'd (out of stock)"
   → Publishes event: PREFERRED_ITEM_UNAVAILABLE
   
2. Decision Synthesis Agent receives event
   → Adjusts recommendations in real-time
   → Publishes: RECOMMENDATION_UPDATED
   
3. Staff Briefing Agent subscribes to RECOMMENDATION_UPDATED
   → Automatically regenerates briefing with alternative suggestion
   
4. Show event log in real-time during demo
```

### **2. Human-in-the-Loop Decision Point**

**Scenario:**
- Decision Agent identifies: "Guest complained about noise in past"
- **Pause workflow** → Send to manager for approval:
  ```
  Decision required: Offer table upgrade to private dining room?
  - Cost: $50 upcharge waived
  - Risk: May seem too aggressive
  - Reward: Address past concern proactively
  
  [Approve] [Modify] [Decline]
  ```
- Manager clicks "Approve" → Workflow resumes with updated action

### **3. Shared Memory Inspection**

**Demo Action:**
- Pause workflow after Phase 1 (Intelligence Gathering)
- Open shared memory inspector
- Show JSON structure with all agent outputs
- Manually modify a value (e.g., change sentiment score from 8.5 to 6.0)
- Resume workflow
- Prove Decision Agent adapts to modified context

### **4. Multi-LLM A/B Testing**

**Scenario:**
- Route 50% of guest briefings through GPT-4
- Route 50% through Claude Sonnet
- Show dashboard comparing:
  - Response quality scores (manager feedback)
  - Execution time
  - Cost per execution
- Switch models mid-demo to show agnostic architecture

### **5. MCP Integration Deep Dive** (Fourth iQ via MCP)

**Demo Flow:**
```
1. Show MCP connection config in UI
   → Fourth iQ endpoint, authentication

2. Agent calls MCP tool: send_action()
   → Display request/response JSON in real-time
   → Show action payload structure:
      - title, synopsis, reason, message
      - userCanonicalId, actionId, linkTitle, linkURL
      - locationCanonicalId
   → Switch to Fourth iQ mobile app (if available)
   → Show action appearing on manager's phone in real-time

3. Agent calls MCP tool: send_alert()
   → Display informational alert payload
   → Show difference: alert has no action button, just acknowledgment

4. Demonstrate close_action() workflow
   → Show how external system marks action as completed
   → Action disappears from manager's active tasks

5. Simulate MCP failure (disconnect)
   → Show agent retry logic + graceful degradation
   → Agent queues action for later vs. blocking

6. Show mock data sources
   → Demonstrate staff schedules from Google Sheets/SQLite
   → Show menu/inventory data from mock APIs
   → Explain that these would normally come from other Fourth systems
```

---

## **Requirements Coverage Matrix**

| Requirement ID | Requirement | How Demonstrated |
|----------------|-------------|------------------|
| REQ-001 | White Labeling | Deploy at custom domain with Fourth branding |
| REQ-003 | LLM Agnostic | Switch between GPT-4/Claude during demo; A/B test |
| REQ-005 | Budget | 90-day POC, ~5,000 agent executions, €8k |
| REQ-007 | Regional Deployment | EU instance for GDPR customers |
| REQ-009 | Low-code + Code | Visual workflow builder + custom Python logic |
| REQ-010 | RAG & Vector DB | Knowledge base for guest history, preferences |
| REQ-013 | MCP Support | Native Fourth MCP integration (bidirectional) |
| REQ-015 | Performance SLA | <2s from webhook to first action |
| REQ-016 | Scale | Simulate 100+ concurrent guest bookings |
| REQ-018 | Multi-Agent | 5 specialized action agents with event bus coordination |
| REQ-019 | GDPR/SOC2 | Compliance documentation verification |
| REQ-020 | Multi-Tenant | Isolated data per restaurant group tenant |

---

## **Success Metrics for Demo**

### **Technical Validation:**
- [ ] Webhook trigger → First action execution in <2 seconds
- [ ] 4+ agents orchestrated with visible event bus
- [ ] Shared memory accessible/modifiable mid-execution
- [ ] Actions delivered to 3+ channels (Fourth iQ via MCP, Email)
- [ ] MCP integration with bidirectional data flow
- [ ] Human approval workflow demonstrates pause/resume
- [ ] Multi-LLM switching operational
- [ ] RAG queries with vector similarity search

### **Business Validation:**
- [ ] Guest experience clearly enhanced by AI intelligence
- [ ] Next Best Actions are specific and actionable
- [ ] Staff efficiency improved (automated briefings)
- [ ] Demonstrates hospitality-specific use case
- [ ] ROI obvious (loyalty retention, upsell opportunities)
- [ ] Platform usable by non-technical operators

---

## **Critical Questions for Vendors**

### **White-Labeling:**
1. Can you deploy this at `intelligence.fourth.com` with zero vendor branding?
2. Show me the CSS/theme customization interface
3. Can customers' customers (restaurant operators) tell this isn't Fourth's platform?

### **Multi-Agent Orchestration:**
4. Show me the event bus logs during execution
5. How do I inspect/modify shared memory mid-workflow?
6. Can agents run in parallel vs sequential? Prove it.

### **MCP Integration** (Fourth iQ via MCP):
7. How long to integrate a new MCP server?
8. Show me error handling when MCP connection fails
9. Can you demonstrate bidirectional data flow? (send_action → manager action → close_action)
10. Show me the difference between send_action and send_alert in the UI

### **Multi-Tenant Architecture:**
10. How is data isolated between restaurant groups?
11. Can one tenant access another's agent configurations?
12. Show me the database architecture for tenant separation

### **Performance & Scale:**
13. What's your actual 90th percentile response time under load?
14. How does auto-scaling work? Show me.
15. What happens when rate limits are hit?

---

## **Why This Demo Scenario is Ideal**

1. **Proactive vs. Reactive:** Shows AI adding value before guest arrives, not just fixing problems
2. **Multi-Channel Showcase:** Fourth iQ actions/alerts (via MCP), email proves versatility
3. **Complex Orchestration:** 5 specialized action agents with clear dependencies and event-driven communication
4. **Hospitality-Specific:** Speaks directly to restaurant/hotel operators with familiar use case
5. **Measurable Impact:** Easy to quantify ROI (guest satisfaction, repeat visits, upsell opportunities)
6. **Human-in-the-Loop:** Shows AI augments staff decisions, doesn't replace them
7. **MCP Integration Central:** MCP integration is clearly critical to the value proposition, not peripheral
8. **Hard Requirements Visible:** Forces vendors to prove multi-agent orchestration, white-labeling, MCP, performance

---

## **Vendor Demo Failure Red Flags**

- ❌ "Multi-agent orchestration requires custom code"
- ❌ "MCP support coming in next release" (or "MCP requires custom development")
- ❌ "White-labeling is limited to logo and colors"
- ❌ "Event bus not exposed to users"
- ❌ "Shared memory not directly accessible"
- ❌ "Performance depends on your infrastructure"
- ❌ "Multi-tenant via separate deployments"
- ❌ "Human-in-the-loop needs custom development"

---

## **Next Steps**

1. Share this scenario with vendors 1 week before demo
2. Request they prepare working implementation (not slides)
3. Allocate 90 minutes for live demonstration
4. Bring Fourth iQ test MCP server for real integration (or use mock MCP server with send_action/send_alert/close_action endpoints)
5. Prepare evaluation scorecard based on requirements matrix
6. Record demo for internal review and comparison

---

**Document Version:** 1.0  
**Last Updated:** December 2024  
**Owner:** Fourth Platform Evaluation Team
