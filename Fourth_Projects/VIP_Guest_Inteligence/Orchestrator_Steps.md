# VIP Guest Intelligence Orchestrator - Step-by-Step Instructions

## Webhook Configuration (Step 1)

### Configure Webhook Node to Receive Booking System Payload

**Node Settings:**
- **HTTP Method:** `POST` (or enable "Allow Multiple HTTP Methods" if booking system uses different methods)
- **Path:** `reservation-webhook` (or leave empty for default path)
- **Response Mode:** `On Received` (responds immediately with 200 OK)
- **Authentication:** 
  - **None** - If booking system doesn't require auth
  - **Header Auth** - If booking system sends API key in header (e.g., `X-API-Key`)
  - **Basic Auth** - If booking system uses HTTP Basic Authentication
  - **Custom Header** - For custom authentication schemes

**Expected Payload Structure:**
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

**Note:** `loyalty_tier` is NOT in the webhook payload. It will be fetched from CRM in Phase 2 using `guest_id`.

**Step-by-Step Configuration:**

1. **HTTP Method:** 
   - Select `POST` from dropdown (already configured ✓)

2. **Path:**
   - Enter: `reservation` (or `reservation-webhook` if you prefer)
   - This creates URL: `http://localhost:5680/webhook-test/reservation` (test mode)
   - Production URL will be: `http://localhost:5680/webhook/reservation`
   - **Note:** For static paths (no `:` dynamic segments), the webhook ID is NOT included in the URL

3. **Authentication:**
   - Select `None` (if booking system doesn't require auth)
   - Or configure Header Auth/Basic Auth if needed

4. **Respond:**
   - Select `Immediately` (responds with 200 OK right away)
   - This is correct for webhook triggers

5. **Test the Configuration:**
   - Click **"Listen for test event"** button (top right)
   - Copy the Test URL shown (e.g., `POST http://localhost:5678/webhook-test/reservation`)
   - Send test payload using curl or Postman (see Testing section below)

**Important Docker Configuration:**

If running n8n in Docker with a different external port (e.g., 5680), the webhook URLs will show the wrong port by default. To fix this:

**Set the `WEBHOOK_URL` environment variable in Docker:**

```yaml
# In docker-compose.yml
services:
  n8n:
    image: n8nio/n8n
    ports:
      - "5680:5678"  # External:Internal port mapping
    environment:
      - WEBHOOK_URL=http://localhost:5680/  # Use external port
      # OR if using a domain:
      - WEBHOOK_URL=https://your-domain.com/
```

**Or using environment file (.env):**
```bash
WEBHOOK_URL=http://localhost:5680/
```

**Or when running docker run:**
```bash
docker run -p 5680:5678 -e WEBHOOK_URL=http://localhost:5680/ n8nio/n8n
```

**Note:** 
- `WEBHOOK_URL` should point to the **external URL** where n8n is accessible (port 5680 in your case)
- Include the trailing slash `/`
- This will update both test and production webhook URLs shown in the node
- If `WEBHOOK_URL` is not set, n8n defaults to `http://localhost:5678` (internal port)

**Important:** The webhook node automatically accepts JSON payloads. No additional configuration needed - just ensure your booking system sends the payload structure above.

**Webhook URL:**
- **Test Mode:** Click "Listen for Test Event" button to get test URL
  - Format: `http://localhost:5680/webhook-test/reservation` (for static path "reservation")
- **Production Mode:** Activate workflow to get production URL
  - Format: `http://localhost:5680/webhook/reservation` (for static path "reservation")
  - **Note:** Webhook ID is only added for dynamic paths (containing `:`) or when using full path mode

**Configure Booking System:**
1. Copy the production webhook URL from n8n (shown in the Webhook node after activating workflow)
2. In booking system, add webhook endpoint:
   - URL: `http://localhost:5680/webhook/reservation` (copy exact URL from n8n node)
   - Method: `POST`
   - Headers: Add authentication headers if configured
   - Body: JSON payload matching structure above
3. Test webhook by creating a test reservation

**Accessing Payload Data in Workflow:**
- `{{ $json.reservation_id }}` - Reservation ID
- `{{ $json.guest_id }}` - Guest ID (used to lookup loyalty_tier from CRM)
- `{{ $json.arrival_date }}` - Arrival date
- `{{ $json.party_size }}` - Number of guests
- `{{ $json.occasion }}` - Special occasion
- `{{ $json.special_requests }}` - Special requests string

**Note:** `loyalty_tier` is fetched from CRM in Phase 2, not from webhook payload.

**Testing the Webhook:**

1. **Test Mode (Development):**
   - Click **"Listen for test event"** button in Webhook node
   - Copy the Test URL shown (e.g., `POST http://localhost:5678/webhook-test/reservation`)
   - Use curl or Postman to send test payload:
   ```bash
   # Replace with your actual test URL from the webhook node
   curl -X POST http://localhost:5678/webhook-test/reservation \
     -H "Content-Type: application/json" \
     -d '{
       "reservation_id": "RES-2025-001234",
       "guest_id": "GUEST-98765",
       "arrival_date": "2025-12-22",
       "party_size": 4,
       "occasion": "Anniversary",
       "special_requests": "Quiet table, vegetarian options"
     }'
   ```
   - Execution will appear in editor for debugging
   - Click on the execution to inspect the received payload

2. **Production Mode:**
   - Activate workflow
   - Use production webhook URL
   - Executions appear in executions list

**Handling Different Payload Formats:**

If booking system sends nested data or different structure, use **Code node** after Webhook to normalize:

```javascript
// Example: If payload is nested like { "data": { "reservation": {...} } }
const payload = $input.item.json;
return [{
  json: {
    reservation_id: payload.data?.reservation?.id || payload.reservation_id,
    guest_id: payload.data?.guest?.id || payload.guest_id,
    loyalty_tier: payload.data?.loyalty?.tier || payload.loyalty_tier,
    arrival_date: payload.data?.reservation?.arrival_date || payload.arrival_date,
    party_size: payload.data?.reservation?.party_size || payload.party_size,
    occasion: payload.data?.reservation?.occasion || payload.occasion,
    special_requests: payload.data?.reservation?.special_requests || payload.special_requests
  }
}];
```

**Validating Payload Structure (Optional but Recommended):**

Add a **Code node** immediately after the Webhook node to validate and ensure payload structure:

```javascript
// Validate and normalize webhook payload
// Webhook node outputs: { headers, params, query, body }
// The actual payload is in the 'body' property
const payload = $input.item.json.body;

// Check required fields (loyalty_tier is NOT in payload - will be fetched from CRM)
const requiredFields = ['reservation_id', 'guest_id', 'arrival_date', 'party_size'];
const missingFields = requiredFields.filter(field => !payload[field]);

if (missingFields.length > 0) {
  throw new Error(`Missing required fields: ${missingFields.join(', ')}`);
}

// Return normalized payload
return [{
  json: {
    reservation_id: payload.reservation_id,
    guest_id: payload.guest_id,
    // Note: loyalty_tier will be fetched from CRM in Phase 2 using guest_id
    arrival_date: payload.arrival_date,
    party_size: Number(payload.party_size), // Ensure it's a number
    occasion: payload.occasion || null,
    special_requests: payload.special_requests || null
  }
}];
```

This ensures:
- Required fields are present
- Data types are correct (party_size is a number)
- Optional fields have defaults
- Workflow fails early if payload is invalid

---

## Phase 1: Trigger & Initial Setup

1. **Webhook node** - Receive reservation webhook from booking system (configured above)
2. **Code node** (optional) - Validate payload structure (see above)
3. **Set node** - Extract and normalize webhook payload (if not using Code node validation):
   - Set fields using expressions:
     - `reservation_id`: `{{ $json.reservation_id }}`
     - `guest_id`: `{{ $json.guest_id }}`
     - `loyalty_tier`: `{{ $json.loyalty_tier }}`
     - `arrival_date`: `{{ $json.arrival_date }}`
     - `party_size`: `{{ $json.party_size }}`
     - `occasion`: `{{ $json.occasion }}`
     - `special_requests`: `{{ $json.special_requests }}`
   - **Note:** If you used the Code node validation above, this step is optional as payload is already normalized
4. **Set node** - Initialize shared memory object structure

## Phase 2: Data Gathering (Step 1 - Parallel HTTP Requests)

4. **HTTP Request node** - Fetch guest profile from CRM (Google Sheets API or mock endpoint)
   - **Query by:** `guest_id` from webhook payload
   - **Returns:** Guest profile including `loyalty_tier`, preferences, visit history, contact info
5. **HTTP Request node** - Fetch guest order history from POS system (mock endpoint)
   - **Query by:** `guest_id` from webhook payload
6. **HTTP Request node** - Query RAG/Vector DB for brand protocols and VIP standards
7. **HTTP Request node** - Fetch recent reviews from review platforms (Google/TripAdvisor API or mock)
   - **Query by:** `guest_id` from webhook payload
8. **Merge node** - Combine all data sources into shared memory structure
   - **Note:** `loyalty_tier` comes from CRM response, not webhook payload

## Phase 3: Context Analysis (Step 2 - LLM Processing)

9. **Code node** - Prepare context analysis prompt with guest data, reviews, reservation details
10. **OpenAI/LLM node** - Run sentiment analysis on reviews and extract preferences
11. **Set node** - Store sentiment analysis results in shared memory (overall_sentiment, positive_mentions, concerns)

## Phase 4: Multi-Step Reasoning (Step 3 - Decision Logic)

12. **HTTP Request node** - Query mock menu/inventory API to check item availability
13. **HTTP Request node** - Query mock staff schedule API to find available top-rated servers
14. **HTTP Request node** - Query mock table assignment API to find optimal table
15. **Code node** - Classify priority level (VIP-High/Medium/Low) based on loyalty tier + occasion + visit frequency
16. **Code node** - Match menu items with guest preferences and dietary restrictions
17. **Code node** - Generate Next Best Actions bundle (table assignment, staff assignment, menu recommendations, personalized touches)
18. **Set node** - Store complete recommendations in shared memory

## Phase 5: Parallel Action Execution (Step 4 - Sub-Agent Calls)

### Agent 1: Fourth iQ Action Agent
19. **Set node** - Prepare send_action payload (title, synopsis, reason, message, actionId, linkURL, etc.)
20. **MCP node** (or HTTP Request if MCP not available) - Call Fourth MCP `send_action` tool to create VIP task for manager

### Agent 2: Staff Briefing Agent
21. **Code node** - Generate staff briefing markdown document using shared memory data
22. **Set node** - Prepare send_alert payload for briefing notification
23. **MCP node** (or HTTP Request) - Call Fourth MCP `send_alert` tool to notify staff
24. **Email node** (optional) - Send briefing document to assigned server if email available

### Agent 3: Guest Communications Agent
25. **Code node** - Generate personalized pre-visit email content using LLM
26. **Email node** - Send welcome email to guest immediately

### Agent 4: Guest Reminder Agent
27. **Schedule Trigger node** - Schedule email reminder 24h before arrival
28. **Code node** - Generate reminder email with parking/arrival details
29. **Email node** - Send reminder email at scheduled time

### Agent 5: Profile Update Agent
30. **HTTP Request node** - Update guest profile in CRM (Google Sheets API or mock endpoint) with latest preferences
31. **Set node** - Store update confirmation for later use

## Phase 6: Post-Execution (Optional)

32. **Wait node** - Wait for visit completion (or manual trigger)
33. **MCP node** (or HTTP Request) - Call Fourth MCP `close_action` tool to mark action as completed

---

## Alternative: Using Sub-Workflows

If using n8n sub-workflows for agents:

- **Execute Workflow node** - Call "Fourth iQ Action Agent" sub-workflow
- **Execute Workflow node** - Call "Staff Briefing Agent" sub-workflow  
- **Execute Workflow node** - Call "Guest Communications Agent" sub-workflow
- **Execute Workflow node** - Call "Guest Reminder Agent" sub-workflow
- **Execute Workflow node** - Call "Profile Update Agent" sub-workflow

Each sub-workflow receives shared memory data as input and returns results.

---

## Key n8n Nodes Used

- **Webhook** - Trigger
- **HTTP Request** - External API calls (CRM, POS, menu, staff, tables)
- **Code** - Custom logic and data transformation
- **Set** - Data manipulation and shared memory management
- **Merge** - Combine parallel data streams
- **Email** - Send emails
- **MCP** - Fourth iQ MCP tool calls (send_action, send_alert, close_action)
- **Schedule Trigger** - Delayed actions (24h reminder)
- **Execute Workflow** - Sub-agent orchestration (if using sub-workflows)
- **OpenAI/LLM** - Sentiment analysis and content generation
- **Wait** - Pause for human approval or timing

