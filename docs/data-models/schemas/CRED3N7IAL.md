# CRED3N7IAL Collection Schema

User credentials, balances, jackpot tracking, and configuration.

## Document Structure

```json
{
  "_id": "username",
  "Password": "base64nonce:base64ciphertext:base64tag",
  "Username": "username",
  "House": "FireKirin",
  "Category": "slots",
  "Enabled": true,
  "Banned": false,
  "Balance": 100.50,
  "LastUpdated": "2026-01-15T10:30:00Z",
  "Jackpots": {
    "Grand": 1500.00,
    "Major": 400.00,
    "Minor": 80.00,
    "Mini": 15.00
  },
  "Thresholds": {
    "Grand": 1785,
    "Major": 565,
    "Minor": 117,
    "Mini": 23
  },
  "DPD": {
    "GrandDPD": 150.5,
    "MajorDPD": 45.2,
    "MinorDPD": 12.8,
    "MiniDPD": 3.5,
    "Toggles": {
      "GrandPopped": false,
      "MajorPopped": false,
      "MinorPopped": false,
      "MiniPopped": false
    }
  },
  "Settings": {
    "SpinGrand": true,
    "SpinMajor": true,
    "SpinMinor": true,
    "SpinMini": true
  }
}
```

## Field Reference

### Identification Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `_id` | string | Yes | Username (primary key) |
| `Username` | string | Yes | Display username |
| `House` | string | Yes | Platform (FireKirin, OrionStars) |
| `Category` | string | No | Game category (slots, fish) |

### Status Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Enabled` | bool | true | Active status |
| `Banned` | bool | false | Banned status |
| `LastUpdated` | DateTime | Now | Last modification time |

### Security Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `Password` | string | Yes | AES-256-GCM encrypted password |

**Encryption Format**: `"base64(nonce):base64(ciphertext):base64(tag)"`

### Financial Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Balance` | double | 0.0 | Current account balance |

### Jackpot Fields

| Field | Type | Description |
|-------|------|-------------|
| `Jackpots.Grand` | double | Current Grand jackpot value |
| `Jackpots.Major` | double | Current Major jackpot value |
| `Jackpots.Minor` | double | Current Minor jackpot value |
| `Jackpots.Mini` | double | Current Mini jackpot value |

### Threshold Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Thresholds.Grand` | double | 1785 | Grand jackpot threshold |
| `Thresholds.Major` | double | 565 | Major jackpot threshold |
| `Thresholds.Minor` | double | 117 | Minor jackpot threshold |
| `Thresholds.Mini` | double | 23 | Mini jackpot threshold |

### DPD (Dollars Per Day) Fields

| Field | Type | Description |
|-------|------|-------------|
| `DPD.GrandDPD` | double | Grand tier DPD rate |
| `DPD.MajorDPD` | double | Major tier DPD rate |
| `DPD.MinorDPD` | double | Minor tier DPD rate |
| `DPD.MiniDPD` | double | Mini tier DPD rate |

### Toggle Fields (Jackpot Detection)

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `DPD.Toggles.GrandPopped` | bool | false | Grand pop detected |
| `DPD.Toggles.MajorPopped` | bool | false | Major pop detected |
| `DPD.Toggles.MinorPopped` | bool | false | Minor pop detected |
| `DPD.Toggles.MiniPopped` | bool | false | Mini pop detected |

### Settings Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Settings.SpinGrand` | bool | true | Enable Grand tier signals |
| `Settings.SpinMajor` | bool | true | Enable Major tier signals |
| `Settings.SpinMinor` | bool | true | Enable Minor tier signals |
| `Settings.SpinMini` | bool | true | Enable Mini tier signals |

## Validation Rules

### Required Fields
- `_id` (string, non-empty)
- `Password` (string, non-empty)
- `House` (string, non-empty)
- `Username` (string, non-empty)

### Value Constraints

```csharp
// Balance must be non-negative
Balance >= 0

// Jackpot values must be non-negative
Jackpots.Grand >= 0
Jackpots.Major >= 0
Jackpots.Minor >= 0
Jackpots.Mini >= 0

// DPD values must be non-negative
DPD.GrandDPD >= 0
DPD.MajorDPD >= 0
DPD.MinorDPD >= 0
DPD.MiniDPD >= 0

// Threshold sanity checks
Thresholds.Mini <= 30
Thresholds.Minor <= 134
Thresholds.Major <= 630
Thresholds.Grand <= 1800
```

## Indexes

```javascript
// Primary key (automatic)
{ _id: 1 }

// Platform queries
db.CRED3N7IAL.createIndex({ "House": 1 })

// Active credential queries
db.CRED3N7IAL.createIndex({ "Enabled": 1, "Banned": 1 })

// Last updated for staleness checks
db.CRED3N7IAL.createIndex({ "LastUpdated": -1 })
```

## Common Queries

### Get Active Credentials for Platform
```javascript
db.CRED3N7IAL.find({
  "House": "FireKirin",
  "Enabled": true,
  "Banned": false
})
```

### Update Jackpot Values
```javascript
db.CRED3N7IAL.updateOne(
  { "_id": "username" },
  {
    $set: {
      "Jackpots.Grand": 1500.00,
      "LastUpdated": new Date()
    }
  }
)
```

### Check for Stale Credentials
```javascript
db.CRED3N7IAL.find({
  "LastUpdated": { $lt: new Date(Date.now() - 24 * 60 * 60 * 1000) }
})
```

## Code Examples

### Creating a Credential (C#)
```csharp
var credential = new Credential
{
    Id = "myusername",
    Username = "myusername",
    House = "FireKirin",
    Password = encryptionService.EncryptToString("mypassword"),
    Enabled = true,
    Balance = 100.0,
    Thresholds = new Thresholds
    {
        Grand = 1785,
        Major = 565,
        Minor = 117,
        Mini = 23
    }
};

await unitOfWork.Credentials.AddAsync(credential);
await unitOfWork.SaveChangesAsync();
```

### Reading and Decrypting Password (C#)
```csharp
var credential = await unitOfWork.Credentials.GetAsync("myusername");
string decryptedPassword = encryptionService.DecryptFromString(credential.Password);
```

### Updating Balance with Validation (C#)
```csharp
var credential = await unitOfWork.Credentials.GetAsync("myusername");
credential.Balance = newBalance;

if (!credential.IsValid(errorStore))
{
    // Validation errors logged to ERR0R collection
    return;
}

await unitOfWork.Credentials.UpdateAsync(credential);
await unitOfWork.SaveChangesAsync();
```

## Related Entities

- [`Jackpot`](JACKP0T.md) - Historical jackpot data
- [`DPD`](entities/dpd.md) - DPD calculation details
- [`Thresholds`](entities/thresholds.md) - Threshold configuration

## Safety Considerations

1. **Password Encryption**: Always encrypted with AES-256-GCM
2. **Master Key**: Required for decryption, stored separately
3. **Audit Logging**: All access logged to ERR0R collection
4. **Balance Validation**: Negative balances rejected

## Migration Notes

### From v1 to v2
- Added `DPD` structure with toggles
- Added `Settings` for tier control
- Password encryption now mandatory
- Removed `Game` reference (now House + Category)

---

**Related**: [Data Models Overview](../INDEX.md) | [ERR0R Collection](ERR0R.md) | [API Reference](../../api-reference/entities/credential.md)
