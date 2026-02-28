description: Updates the Network Controller binaries
synopses:
- Update-NetworkController [-Update <UpdateType>] [-Force] [-ComputerName <String>]
  [-UseSsl] [-Credential <PSCredential>] [-CertificateThumbprint <String>] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -ComputerName String: ~
  -Credential PSCredential: ~
  -Force Switch: ~
  -Update UpdateType:
    values:
    - Default
    - Application
    - Cluster
  -UseSsl Switch: ~
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
