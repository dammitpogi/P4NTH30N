> ## Documentation Index
> Fetch the complete documentation index at: https://docs.windsurf.com/llms.txt
> Use this file to discover all available pages before exploring further.

# Get Team Credit Balance

> Retrieve the current credit balance for your team, including prompt credits per seat, add-on credits, and billing cycle information.

## Overview

Retrieve the current credit balance information for your team. This includes prompt credits allocated per seat, the number of seats, add-on credit usage, and billing cycle dates.

## Request

<ParamField body="service_key" type="string" required>
  Your service key with "Billing Read" permissions
</ParamField>

### Example Request

```bash  theme={null}
curl -X POST --header "Content-Type: application/json" \
--data '{
  "service_key": "your_service_key_here"
}' \
https://server.codeium.com/api/v1/GetTeamCreditBalance
```

## Response

<ResponseField name="promptCreditsPerSeat" type="integer">
  Number of prompt credits allocated per seat for the current billing cycle
</ResponseField>

<ResponseField name="numSeats" type="integer">
  Number of seats on the team
</ResponseField>

<ResponseField name="addOnCreditsAvailable" type="integer">
  Total add-on credits available for the team
</ResponseField>

<ResponseField name="addOnCreditsUsed" type="integer">
  Add-on credits consumed so far in the current billing cycle
</ResponseField>

<ResponseField name="billingCycleStart" type="string">
  Start of the current billing cycle (ISO 8601 timestamp)
</ResponseField>

<ResponseField name="billingCycleEnd" type="string">
  End of the current billing cycle (ISO 8601 timestamp)
</ResponseField>

### Example Response

```json  theme={null}
{
  "promptCreditsPerSeat": 500,
  "numSeats": 50,
  "addOnCreditsAvailable": 10000,
  "addOnCreditsUsed": 3500,
  "billingCycleStart": "2026-01-01T00:00:00Z",
  "billingCycleEnd": "2026-02-01T00:00:00Z"
}
```

## Error Responses

Common error scenarios:

* Invalid service key or insufficient permissions
* Feature not available for your plan (requires enterprise tier)
* Rate limit exceeded
