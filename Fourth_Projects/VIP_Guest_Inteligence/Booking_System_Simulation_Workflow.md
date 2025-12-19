# Booking System Simulation Workflow

This workflow simulates a booking system where guests can make reservations. It uses an n8n Form Trigger to collect reservation data and sends it to the orchestrator workflow via webhook.

**Environment Configuration:** The HTTP Request node can automatically select the correct orchestrator URL based on environment variables or workflow status (see Step 3 and Environment Configuration section).

---

## Workflow Overview

```
Form Trigger → Set Node (Format Payload) → HTTP Request (Send to Orchestrator)
```

**Note:** The `reservation_id` is automatically generated using the execution ID (`RES-{execution.id}`) - no form field needed for this.

---

## Step-by-Step Configuration

### Step 1: Create Form Trigger Node

**Node:** `n8n Form Trigger`

**Configuration:**

1. **Form Title:**
   - Enter: `Restaurant Reservation Form`

2. **Form Description:**
   - Enter: `Please fill out the form below to make your reservation`

3. **Path:**
   - Enter: `booking-form` (or leave empty for auto-generated path)
   - This creates URL: `http://localhost:5678/form/booking-form` (or similar)

4. **Response Mode:**
   - Select: `Immediately` (responds right away after form submission)

5. **Form Submitted Text:**
   - Enter: `Thank you! Your reservation has been received. We'll send you a confirmation shortly.`

6. **Form Elements (Fields):**

   Add the following fields in order:

   **Field 1: Guest ID**
   - **Element Type:** `Text`
   - **Field Name:** `guest_id`
   - **Label:** `Guest ID`
   - **Placeholder:** `e.g., GUEST-98765`
   - **Required Field:** ✓ Yes
   - **Note:** Loyalty tier will be looked up from CRM using this guest ID

   **Field 2: Arrival Date**
   - **Element Type:** `Date`
   - **Field Name:** `arrival_date`
   - **Label:** `Arrival Date`
   - **Required Field:** ✓ Yes

   **Field 3: Party Size**
   - **Element Type:** `Number`
   - **Field Name:** `party_size`
   - **Label:** `Number of Guests`
   - **Placeholder:** `e.g., 4`
   - **Required Field:** ✓ Yes

   **Field 4: Occasion**
   - **Element Type:** `Dropdown`
   - **Field Name:** `occasion`
   - **Label:** `Special Occasion (Optional)`
   - **Required Field:** ✗ No
   - **Dropdown Options:**
     - `Anniversary`
     - `Birthday`
     - `Business Dinner`
     - `Date Night`
     - `Family Gathering`
     - `None`

   **Field 5: Special Requests**
   - **Element Type:** `Textarea`
   - **Field Name:** `special_requests`
   - **Label:** `Special Requests or Dietary Requirements`
   - **Placeholder:** `e.g., Quiet table, vegetarian options, shellfish allergy`
   - **Required Field:** ✗ No

---

### Step 2: Set Node - Format Payload

**Node:** `Set`

**Purpose:** Format form data into the exact payload structure expected by orchestrator, using execution ID as reservation_id

**Configuration:**

**Mode:** `Manual`

**Fields to Set:**

1. **reservation_id**
   - Value: `{{ "RES-" + $execution.id }}`
   - **Note:** Uses execution ID from workflow context (internal property)

2. **guest_id**
   - Value: `{{ $json.guest_id }}`
   - **Note:** Loyalty tier will be looked up by orchestrator from CRM using this guest_id

3. **arrival_date**
   - Value: `{{ $json.arrival_date }}`
   - **Note:** If date format needs conversion, use Code node instead

4. **party_size**
   - Value: `{{ Number($json.party_size) }}`
   - **Note:** Convert to number type

5. **occasion**
   - Value: `{{ $json.occasion || "" }}`

6. **special_requests**
   - Value: `{{ $json.special_requests || "" }}`

**Alternative: Use Code Node for Date Formatting**

If you need to format the date, replace Set node with Code node:

```javascript
// Format payload and convert date
const formData = $input.item.json;

// Format date to YYYY-MM-DD if needed
let arrivalDate = formData.arrival_date;
if (arrivalDate && arrivalDate.includes('T')) {
  arrivalDate = arrivalDate.split('T')[0];
}

// Use execution ID as reservation ID
const reservationId = `RES-${$execution.id}`;

return [{
  json: {
    reservation_id: reservationId,
    guest_id: formData.guest_id,
    // Note: loyalty_tier will be looked up by orchestrator from CRM
    arrival_date: arrivalDate,
    party_size: Number(formData.party_size),
    occasion: formData.occasion || "",
    special_requests: formData.special_requests || ""
  }
}];
```

---

### Step 3: HTTP Request Node - Send to Orchestrator

**Node:** `HTTP Request`

**Configuration:**

1. **Method:** `POST`

2. **URL:**
   - **Option 1: Use Environment Variable (Recommended)**
     - Enter: `{{ $env.ORCHESTRATOR_WEBHOOK_URL || "http://localhost:5678/webhook-test/reservation" }}`
     - Set environment variable `ORCHESTRATOR_WEBHOOK_URL` in your n8n instance:
       - **Test:** `ORCHESTRATOR_WEBHOOK_URL=http://localhost:5678/webhook-test/reservation`
       - **Production:** `ORCHESTRATOR_WEBHOOK_URL=http://localhost:5678/webhook/reservation/[webhook-id]`
   
   - **Option 2: Use Execution Mode (Recommended for Test/Production Detection)**
     - **For Docker:** Use internal port `5678` when both workflows are in the same container
     - Enter: `{{ $execution.mode === "production" ? "http://localhost:5678/webhook/reservation" : "http://localhost:5678/webhook/reservation" }}`
     - **Note:** Use production URL (`/webhook/`) for both modes since test listeners are unreliable
     - Automatically switches based on execution mode (though both use production URL)
     - **Why port 5678?** Inside Docker, `localhost:5678` refers to the container's internal port (mapped to 5680 externally)
     - **Important:** Test webhooks (`/webhook-test/`) stop when switching workflows. Always use production URL (`/webhook/`) for cross-workflow communication
   
   - **Option 3: Use Workflow Active Status**
     - **For Docker:** Use internal port `5678` when both workflows are in the same container
     - Enter: `{{ $workflow.active ? "http://localhost:5678/webhook/reservation" : "http://localhost:5678/webhook/reservation" }}`
     - **Note:** Use production URL for both states since test listeners are unreliable
     - **Why port 5678?** Inside Docker, `localhost:5678` refers to the container's internal port
     - **Important:** Always activate orchestrator workflow and use production URL for reliable cross-workflow communication

3. **Send Body:** ✓ Yes

4. **Content-Type:** `JSON`

5. **Specify Body:** `Using JSON`

6. **JSON:**
   ```json
   {
     "reservation_id": "{{ $json.reservation_id }}",
     "guest_id": "{{ $json.guest_id }}",
     "arrival_date": "{{ $json.arrival_date }}",
     "party_size": {{ $json.party_size }},
     "occasion": "{{ $json.occasion }}",
     "special_requests": "{{ $json.special_requests }}"
   }
   ```
   **Note:** 
   - `reservation_id` comes from the Set node which uses `{{ "RES-" + $execution.id }}`
   - `loyalty_tier` is NOT sent here - it will be looked up by orchestrator from CRM using `guest_id`

   **Or use expressions directly:**
   - Click "Using Fields Below" instead
   - Add each field as a parameter:
     - Name: `reservation_id`, Value: `{{ "RES-" + $execution.id }}`
     - Name: `guest_id`, Value: `{{ $json.guest_id }}`
     - Name: `arrival_date`, Value: `{{ $json.arrival_date }}`
     - Name: `party_size`, Value: `{{ $json.party_size }}`
     - Name: `occasion`, Value: `{{ $json.occasion }}`
     - Name: `special_requests`, Value: `{{ $json.special_requests }}`
     - **Note:** Do NOT include `loyalty_tier` - orchestrator will look it up from CRM

---

## Testing the Workflow

### 1. Test Form Submission

1. **Activate the workflow** (or use test mode)
2. **Copy the Form URL** from the Form Trigger node
   - Format: `http://localhost:5678/form/booking-form` (or similar)
3. **Open the URL in a browser**
4. **Fill out the form:**
   - Guest ID: `GUEST-98765`
   - Arrival Date: Select a future date
   - Party Size: `4`
   - Occasion: `Anniversary`
   - Special Requests: `Quiet table, vegetarian options`
   - **Note:** Loyalty tier is not entered - orchestrator will look it up from CRM
5. **Submit the form**
6. **Check the execution** in n8n to verify:
   - Form data was received correctly
   - Payload was formatted properly
   - HTTP Request was sent to orchestrator

### 2. Verify Orchestrator Receives Data

1. **Check orchestrator workflow execution**
2. **Verify payload structure matches:**
   ```json
   {
     "reservation_id": "RES-{execution-id}",
     "guest_id": "GUEST-98765",
     "arrival_date": "2025-12-22",
     "party_size": 4,
     "occasion": "Anniversary",
     "special_requests": "Quiet table, vegetarian options"
   }
   ```
   **Note:** 
   - `reservation_id` will be auto-generated as `RES-{execution-id}` where `{execution-id}` is the n8n execution ID
   - `loyalty_tier` is NOT in the payload - orchestrator will fetch it from CRM using `guest_id` in Phase 2

---

## Complete Workflow JSON Structure

For reference, here's the expected workflow structure:

```json
{
  "name": "Booking System Simulation",
  "nodes": [
    {
      "parameters": {
        "path": "booking-form",
        "formTitle": "Restaurant Reservation Form",
        "formDescription": "Please fill out the form below to make your reservation",
        "formFields": {
          "values": [
            {
              "fieldType": "text",
              "fieldName": "guest_id",
              "fieldLabel": "Guest ID",
              "requiredField": true
            },
            {
              "fieldType": "date",
              "fieldName": "arrival_date",
              "fieldLabel": "Arrival Date",
              "requiredField": true
            },
            {
              "fieldType": "number",
              "fieldName": "party_size",
              "fieldLabel": "Number of Guests",
              "requiredField": true
            },
            {
              "fieldType": "dropdown",
              "fieldName": "occasion",
              "fieldLabel": "Special Occasion (Optional)",
              "requiredField": false,
              "fieldOptions": {
                "values": [
                  { "option": "Anniversary" },
                  { "option": "Birthday" },
                  { "option": "Business Dinner" },
                  { "option": "Date Night" },
                  { "option": "Family Gathering" },
                  { "option": "None" }
                ]
              }
            },
            {
              "fieldType": "textarea",
              "fieldName": "special_requests",
              "fieldLabel": "Special Requests or Dietary Requirements",
              "requiredField": false
            }
          ]
        },
        "responseMode": "onReceived",
        "options": {
          "formSubmittedText": "Thank you! Your reservation has been received. We'll send you a confirmation shortly."
        }
      },
      "name": "Form Trigger",
      "type": "n8n-nodes-base.formTrigger",
      "typeVersion": 2.4,
      "position": [240, 300]
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            {
              "id": "reservation_id",
              "name": "reservation_id",
              "value": "{{ \"RES-\" + $execution.id }}",
              "type": "string"
            },
            {
              "id": "guest_id",
              "name": "guest_id",
              "value": "{{ $json.guest_id }}",
              "type": "string"
            },
            {
              "id": "arrival_date",
              "name": "arrival_date",
              "value": "{{ $json.arrival_date }}",
              "type": "string"
            },
            {
              "id": "party_size",
              "name": "party_size",
              "value": "{{ Number($json.party_size) }}",
              "type": "number"
            },
            {
              "id": "occasion",
              "name": "occasion",
              "value": "{{ $json.occasion || \"\" }}",
              "type": "string"
            },
            {
              "id": "special_requests",
              "name": "special_requests",
              "value": "{{ $json.special_requests || \"\" }}",
              "type": "string"
            }
          ]
        }
      },
      "name": "Format Payload",
      "type": "n8n-nodes-base.set",
      "typeVersion": 3.4,
      "position": [460, 300]
    },
    {
      "parameters": {
        "method": "POST",
        "url": "http://localhost:5678/webhook-test/reservation",
        "sendBody": true,
        "contentType": "json",
        "specifyBody": "json",
        "jsonBody": "{\n  \"reservation_id\": \"{{ $json.reservation_id }}\",\n  \"guest_id\": \"{{ $json.guest_id }}\",\n  \"arrival_date\": \"{{ $json.arrival_date }}\",\n  \"party_size\": {{ $json.party_size }},\n  \"occasion\": \"{{ $json.occasion }}\",\n  \"special_requests\": \"{{ $json.special_requests }}\"\n}"
      },
      "name": "Send to Orchestrator",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4.2,
      "position": [680, 300]
    }
  ],
  "connections": {
    "Form Trigger": {
      "main": [[{ "node": "Format Payload", "type": "main", "index": 0 }]]
    },
    "Format Payload": {
      "main": [[{ "node": "Send to Orchestrator", "type": "main", "index": 0 }]]
    }
  }
}
```

---

## Environment Configuration

### Docker Networking - Critical for Container-to-Container Communication

**The Problem:**
When both workflows run in the same Docker container, `localhost:5680` doesn't work because:
- Inside the container, `localhost` refers to the container itself
- Port 5680 doesn't exist inside the container (only 5678 does)
- Port 5680 is the external mapping (`5680:5678` means host:5680 → container:5678)

**The Solution:**
Use the **internal port 5678** for container-to-container communication:

```yaml
# In docker-compose.fourth.yml
services:
  fourth-intelligence-studio:
    environment:
      # For external access (browser, curl from host)
      - WEBHOOK_URL=http://localhost:5680/
      # For internal container-to-container communication
      - ORCHESTRATOR_WEBHOOK_URL=http://localhost:5678/webhook/reservation
      # OR use container hostname:
      # - ORCHESTRATOR_WEBHOOK_URL=http://fourth-intelligence-studio:5678/webhook/reservation
```

**Key Points:**
- **External access (from host):** Use `http://localhost:5680/` (external port)
- **Internal access (container-to-container):** Use `http://localhost:5678/` (internal port)
- **Alternative:** Use container hostname: `http://fourth-intelligence-studio:5678/`

### Setting Up Environment Variables

**For Docker/Container deployments:**
```bash
# In docker-compose.fourth.yml
services:
  fourth-intelligence-studio:
    environment:
      # External URL for webhook display (shown in UI)
      - WEBHOOK_URL=http://localhost:5680/
      # Internal URL for HTTP Request nodes (container-to-container)
      - ORCHESTRATOR_WEBHOOK_URL=http://localhost:5678/webhook/reservation
```

**Important:** 
- `WEBHOOK_URL` is for external access (what users see in the UI)
- `ORCHESTRATOR_WEBHOOK_URL` is for internal HTTP Request nodes (use port 5678)

**For direct n8n installation:**
```bash
# In your shell or systemd service file
export ORCHESTRATOR_WEBHOOK_URL="http://localhost:5678/webhook/reservation/[webhook-id]"
```

**Note:** If using Option 2 (`$execution.mode`), you don't need to set any environment variables - n8n automatically detects test vs production based on how the workflow is executed.

**In n8n Cloud:**
- Go to Settings → Environment Variables
- Add `ORCHESTRATOR_WEBHOOK_URL` with your production webhook URL

### Testing Environment Detection

To verify which URL is being used:
1. Add a **Code node** before HTTP Request node
2. Log the selected URL:
   ```javascript
   const testUrl = "http://localhost:5678/webhook-test/reservation";
   const prodUrl = "http://localhost:5678/webhook/reservation/[webhook-id]";
   
   // Option 1: Using environment variable
   const selectedUrl1 = $env.ORCHESTRATOR_WEBHOOK_URL || testUrl;
   
   // Option 2: Using execution mode (recommended)
   const selectedUrl2 = $execution.mode === "production" ? prodUrl : testUrl;
   
   // Option 3: Using workflow active status
   const selectedUrl3 = $workflow.active ? prodUrl : testUrl;
   
   console.log("Execution mode:", $execution.mode);
   console.log("Workflow active:", $workflow.active);
   console.log("Selected URL:", selectedUrl2); // Using Option 2
   
   return [{ json: { ...$input.item.json, debug_url: selectedUrl2, execution_mode: $execution.mode } }];
   ```

---

## Troubleshooting

### Issue: Date format mismatch

**Problem:** Form sends date in ISO format (`2025-12-22T00:00:00.000Z`) but orchestrator expects `YYYY-MM-DD`

**Solution:** Use Code node to format date (see Step 2 alternative)

### Issue: HTTP Request fails - Webhook listener stopped

**Problem:** Error when sending HTTP request: "listener doesn't accept/answer/listen" or webhook stops listening when switching workflows

**Cause:** Test webhook listeners are tied to the workflow session. When you:
- Switch to another workflow
- Navigate away from the orchestrator workflow
- Close the browser tab
- The test listener automatically stops

**Solutions:**

**Option 1: Activate Orchestrator Workflow (Recommended)**
- **Activate** the orchestrator workflow (toggle switch at top)
- Use **production webhook URL** instead of test URL
- Production webhooks persist across workflow switches
- Update HTTP Request URL to: `http://localhost:5680/webhook/reservation` (production)

**Option 2: Keep Both Workflows Open (Unreliable)**
- Open orchestrator workflow in one browser tab
- Open booking form workflow in another tab
- Keep orchestrator tab active with "Listen for test event" running
- **Warning:** Even with both tabs open, test listeners can stop when workflows execute
- **Better:** Use Option 1 (activate workflow) for reliable cross-workflow communication

**Option 3: Use Production URLs for Testing**
- Activate orchestrator workflow
- Use production URL: `http://localhost:5680/webhook/reservation`
- Works even when switching workflows
- Executions appear in executions list (not in editor)

**Quick Fix:**
1. Go to orchestrator workflow
2. Click **Activate** toggle (top right)
3. Copy the **Production URL** from webhook node
4. Update HTTP Request node URL to use production URL
5. Now you can switch workflows freely

### Issue: HTTP Request fails - Connection Refused (ECONNREFUSED)

**Problem:** Error: `connect ECONNREFUSED ::1:5680` or "The service refused the connection"

**Possible Causes:**

1. **IPv6 Connection Issue (Most Common)**
   - Error shows `::1:5680` (IPv6 localhost)
   - Docker container might not be listening on IPv6
   - Node.js HTTP client tries IPv6 first, fails, then tries IPv4

2. **Test Webhook Listener Stopped (Most Likely Cause)**
   - Even with tabs open and "Listening" status shown, test listener can stop when workflows execute
   - Test listeners are ephemeral and tied to the editor session
   - When HTTP Request node executes, it may try to connect after listener has stopped
   - **This is why you see "Listening" but still get ECONNREFUSED**

**Solutions:**

**Solution 1: Use Internal Docker Port (CRITICAL FOR DOCKER)**
- **When both workflows are in the same Docker container, use internal port 5678, not external port 5680**
- Change URL from `http://localhost:5680/...` to `http://localhost:5678/...`
- Inside Docker, `localhost:5678` refers to the container's internal port
- Example: `{{ $execution.mode === "production" ? "http://localhost:5678/webhook/reservation" : "http://localhost:5678/webhook/reservation" }}`
- **Alternative:** Use container hostname: `http://fourth-intelligence-studio:5678/webhook/reservation`

**Solution 2: Activate Orchestrator Workflow (Best Practice - RECOMMENDED)**
- **This is the ONLY reliable solution for cross-workflow communication**
- Activate orchestrator workflow (toggle switch at top)
- **IMPORTANT FOR DOCKER:** When both workflows run in the same Docker container, use the **internal port (5678)** not the external port (5680)
- Use production webhook URL: `http://localhost:5678/webhook/reservation` (internal port)
- Production webhooks are persistent and don't depend on test listener state
- Works regardless of IPv4/IPv6
- Works even when switching workflows
- **Update HTTP Request URL expression to:**
  ```
  {{ $execution.mode === "production" ? "http://localhost:5678/webhook/reservation" : "http://localhost:5678/webhook/reservation" }}
  ```
  (Use internal port 5678 when both workflows are in the same Docker container)

**Solution 3: Verify Test Listener is Active**
- Go to orchestrator workflow
- Click "Listen for test event" button
- Verify it shows "Listening..." status
- Keep that tab active while testing
- If it stops, click "Listen" again

**Solution 4: Check Docker Container**
- Verify container is running: `docker-compose -f docker-compose.fourth.yml ps`
- Check logs: `docker logs fourth-intelligence-studio --tail 50`
- Restart if needed: `docker-compose -f docker-compose.fourth.yml restart`

### Issue: HTTP Request fails - Other causes

**Problem:** Orchestrator webhook URL is incorrect or workflow not active

**Solution:** 
- Verify orchestrator workflow is active
- Copy correct webhook URL from orchestrator webhook node
- Check if test vs production URL is correct
- Ensure port matches your Docker setup (5680)
- Try using `127.0.0.1` instead of `localhost` to force IPv4

### Issue: Form fields not appearing

**Problem:** Form elements not configured correctly

**Solution:**
- Ensure "Field Name" matches exactly (case-sensitive)
- Check required fields are marked correctly
- Verify dropdown options are set up properly

---

## Next Steps

1. **Test the complete flow:**
   - Submit form → Check orchestrator receives data → Verify orchestrator processes correctly

2. **Customize form styling:**
   - Form Trigger node supports custom HTML/CSS (advanced)

3. **Add validation:**
   - Add Code node after Form Trigger to validate data before sending

4. **Add error handling:**
   - Add Error Trigger node to catch HTTP Request failures
   - Send notification if orchestrator is unavailable

