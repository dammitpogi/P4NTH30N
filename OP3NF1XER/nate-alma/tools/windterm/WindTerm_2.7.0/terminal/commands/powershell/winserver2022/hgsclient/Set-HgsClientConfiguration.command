description: Modifies the configuration of a Host Guardian Service client
synopses:
- Set-HgsClientConfiguration [-EnableLocalMode] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-HgsClientConfiguration -KeyProtectionServerUrl <String> -AttestationServerUrl
  <String> -FallbackKeyProtectionServerUrl <String> -FallbackAttestationServerUrl
  <String> [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-HgsClientConfiguration -KeyProtectionServerUrl <String> -AttestationServerUrl
  <String> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AttestationServerUrl String:
    required: true
  -EnableLocalMode Switch: ~
  -FallbackAttestationServerUrl String:
    required: true
  -FallbackKeyProtectionServerUrl String:
    required: true
  -KeyProtectionServerUrl String:
    required: true
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
  -Debug,-db Switch: ~
  -ErrorAction,-ea ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -ErrorVariable,-ev String: ~
  -InformationAction,-ia ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -InformationVariable,-iv String: ~
  -OutVariable,-ov String: ~
  -OutBuffer,-ob Int32: ~
  -PipelineVariable,-pv String: ~
  -Verbose,-vb Switch: ~
  -WarningAction,-wa ActionPreference:
    values:
    - Break
    - Suspend
    - Ignore
    - Inquire
    - Continue
    - Stop
    - SilentlyContinue
  -WarningVariable,-wv String: ~
