# OPENFIXER CONSTRAINT RESOLUTION
## DEPLOY-002: LM Studio Authentication Disable

**Constraint**: LM Studio API requires Bearer token authentication (401 Unauthorized)
**Resolution**: Disable API authentication in LM Studio settings
**Target**: LM Studio running at localhost:1234

---

## STEPS TO RESOLVE

### Step 1: Access LM Studio Settings
1. Open LM Studio application
2. Click gear icon (Settings) in bottom left
3. Navigate to "API Server" section

### Step 2: Disable Authentication
1. Find "API Key" or "Authentication" setting
2. Toggle OFF or uncheck "Require API Key"
3. Click "Save" or "Apply"
4. Restart LM Studio server if prompted

### Step 3: Verify Authentication Disabled
```bash
# Test with curl (should return 200 without Authorization header)
curl http://localhost:1234/v1/models

# Expected: JSON response with available models
# Should NOT return 401 Unauthorized
```

### Step 4: Download Maincoder-1B
```bash
# Create models directory if not exists
mkdir -p "C:\P4NTHE0N\models"

# Download from Hugging Face
# URL: https://huggingface.co/Maincode/Maincoder-1B
# File: maincoder-1b-q4_k.gguf (~0.8GB)
# Place in: C:\P4NTHE0N\models\
```

### Step 5: Load Model in LM Studio
1. Open LM Studio
2. Click "Load Model"
3. Navigate to C:\P4NTHE0N\models\maincoder-1b-q4_k.gguf
4. Select Q4_K quantization
5. Wait for model to load (monitor progress bar)
6. Verify "Server Running" status shows localhost:1234

### Step 6: Re-run Validation Tests
```bash
# Navigate to test directory
cd "C:\P4NTHE0N\tests\pre-validation"

# Run validation script (PowerShell)
.\run-validation.ps1

# Or manual test with curl
curl -X POST http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d @test-configs/test1-valid-config.json
```

### Step 7: Verify Results
Check that results.json shows:
- 5 tests executed
- JSON format valid
- Accuracy >= 80%
- Latency < 2s average

---

## ALTERNATIVE: If LM Studio UI Not Accessible

If you cannot access LM Studio UI directly:

### Option A: Environment Variable (Temporary)
```powershell
# Set dummy token (some versions accept any non-empty value)
$env:LM_API_TOKEN = "dummy-token-for-local-dev"

# Restart LM Studio with env var set
```

### Option B: Config File Edit
```json
// Edit LM Studio config.json (location varies by install)
// Set: "apiKey": null or "requireAuth": false
```

---

## VERIFICATION CHECKLIST

- [ ] LM Studio settings opened
- [ ] API authentication disabled
- [ ] LM Studio restarted (if required)
- [ ] curl test returns 200 (not 401)
- [ ] Maincoder-1B downloaded (~0.8GB)
- [ ] Model loaded in LM Studio
- [ ] Server running at localhost:1234
- [ ] 5 validation tests executed
- [ ] results.json updated with success
- [ ] DEPLOY-002 marked Complete

---

## POST-RESOLUTION

After completing:
1. Update DEPLOY-002 status to "Completed"
2. Notify WindFixer that constraint is resolved
3. WindFixer can proceed with any dependent work

**Estimated Time**: 15-30 minutes
