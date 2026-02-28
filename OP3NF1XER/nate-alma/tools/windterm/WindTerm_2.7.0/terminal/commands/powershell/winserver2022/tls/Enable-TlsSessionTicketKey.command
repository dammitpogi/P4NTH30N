description: Configures a TLS server with a TLS session ticket key
synopses:
- Enable-TlsSessionTicketKey [-ServiceAccountName] <NTAccount> [-Path] <String> [-Password]
  <SecureString> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Force Switch: ~
  -Password SecureString:
    required: true
  -Path,-FullName String:
    required: true
  -ServiceAccountName NTAccount:
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
