description: Enables a network controller node
synopses:
- Enable-NetworkControllerNode -Name <String> [-PassThru] [-IntentRejoin] [-ComputerName
  <String>] [-UseSsl] [-Credential <PSCredential>] [-CertificateThumbprint <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -ComputerName String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -IntentRejoin Switch: ~
  -Name String:
    required: true
  -PassThru Switch: ~
  -UseSsl Switch: ~
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
