description: Imports previously exported Key Protection Service configuration and
  certificates
synopses:
- Import-HgsKeyProtectionState -Password <SecureString> [-Force] [-IgnoreImportFailures]
  [[-Path] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Import-HgsKeyProtectionState -Password <SecureString> [-Force] [-IgnoreImportFailures]
  [[-Xml] <XmlDocument>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Force Switch: ~
  -IgnoreImportFailures Switch: ~
  -Password SecureString:
    required: true
  -Path String: ~
  -Xml XmlDocument: ~
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
