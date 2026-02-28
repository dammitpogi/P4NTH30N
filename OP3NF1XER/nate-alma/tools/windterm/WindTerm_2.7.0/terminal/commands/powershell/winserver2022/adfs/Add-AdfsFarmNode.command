description: Adds this computer to an existing federation server farm
synopses:
- Add-AdfsFarmNode [-OverwriteConfiguration] [-CertificateThumbprint <String>] -GroupServiceAccountIdentifier
  <String> [-Credential <PSCredential>] -PrimaryComputerName <String> [-PrimaryComputerPort
  <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AdfsFarmNode [-OverwriteConfiguration] [-CertificateThumbprint <String>] -ServiceAccountCredential
  <PSCredential> [-Credential <PSCredential>] -PrimaryComputerName <String> [-PrimaryComputerPort
  <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AdfsFarmNode [-CertificateThumbprint <String>] -ServiceAccountCredential <PSCredential>
  [-Credential <PSCredential>] -SQLConnectionString <String> [-FarmBehavior <Int32>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-AdfsFarmNode [-CertificateThumbprint <String>] -GroupServiceAccountIdentifier
  <String> [-Credential <PSCredential>] -SQLConnectionString <String> [-FarmBehavior
  <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -Credential PSCredential: ~
  -FarmBehavior Int32: ~
  -GroupServiceAccountIdentifier String:
    required: true
  -OverwriteConfiguration Switch: ~
  -PrimaryComputerName String:
    required: true
  -PrimaryComputerPort Int32: ~
  -ServiceAccountCredential PSCredential:
    required: true
  -SQLConnectionString String:
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
