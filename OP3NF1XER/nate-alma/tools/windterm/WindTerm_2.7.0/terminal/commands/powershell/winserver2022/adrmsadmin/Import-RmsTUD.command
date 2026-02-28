description: Imports a TUD from a file in AD RMS or specifies to trust Microsoft account
  IDs
synopses:
- Import-RmsTUD [-DisplayName] <String> [-SourceFile] <String> [-TrustADFederatedUser]
  [-PassThru] [-Path] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
- Import-RmsTUD [-WindowsLiveId] [-PassThru] [-Path] <String[]> [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -Confirm,-cf Switch: ~
  -DisplayName String:
    required: true
  -PassThru Switch: ~
  -Path String[]:
    required: true
  -SourceFile String:
    required: true
  -TrustADFederatedUser Switch: ~
  -WhatIf,-wi Switch: ~
  -WindowsLiveId Switch:
    required: true
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
