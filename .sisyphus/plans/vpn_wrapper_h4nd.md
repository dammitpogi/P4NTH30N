# Plan: Wrap H4ND with VPN (IP Rotation)

The goal is to integrate a VPN service into the `H4ND` automation flow to rotate IP addresses while preserving browser session state (cookies/trackers). The solution must adhere to `W4TCHD0G` IP handling rules.

## Tasks

- [x] **Analyze Constraints & Architecture**
  - [x] Review `H4ND` network stack (Selenium/HttpClient usage).
  - [x] Analyze `W4TCHD0G` rules for IP handling.
  - [x] Evaluate `C0MMON/Services/VPNService.cs` capabilities.
- [x] **Design VPN Integration**
  - [x] Determine integration point (e.g., before `H4ND` loop, inside loop, or wrapper script).
  - [x] Design "IP Change" trigger logic (e.g., per session, on error, or timed).
  - [x] Ensure browser profile persistence (verify `Launch.cs` uses user-data-dir).
- [x] **Implement VPN Wrapper**
  - [x] Modify `H4ND/H4ND.cs` or `C0MMON` to call `VPNService`.
  - [x] Implement IP verification (check "rules").
  - [x] Add safety checks (kill switch if IP doesn't change).
- [x] **Verify Implementation**
  - [x] Test IP rotation (log IP before/after).
  - [x] Verify cookies persist (session remains active).
  - [x] Verify `W4TCHD0G` rules compliance.

## Technical Details

**Constraints:**
- **Preserve Cookies**: Do not destroy the Selenium User Data Directory.
- **Solely Change IP**: Do not block trackers or modify headers (unless required for IP mask).
- **W4TCHD0G Rules**: (To be discovered).

**Potential Approach:**
- Use `VPNService.Connect()`/`Disconnect()` within the automation loop.
- Ensure `ChromeDriver` survives the network reconnection OR is restarted with the *same* profile.
- Note: Changing IP might cause WebSocket disconnects in Selenium; verification needed.
