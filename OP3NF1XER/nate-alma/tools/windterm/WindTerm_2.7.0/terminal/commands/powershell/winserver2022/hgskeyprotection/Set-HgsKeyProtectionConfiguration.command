description: Modifies the configuration of the Key Protection Service
synopses:
- Set-HgsKeyProtectionConfiguration -CommunicationsCertificateThumbprint <String>
  [-NoCommunicationsCertificateReplication] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-HgsKeyProtectionConfiguration -CommunicationsCertificatePath <String> [-CommunicationsCertificatePassword
  <SecureString>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CommunicationsCertificatePassword SecureString: ~
  -CommunicationsCertificatePath String:
    required: true
  -CommunicationsCertificateThumbprint String:
    required: true
  -Force Switch: ~
  -NoCommunicationsCertificateReplication Switch: ~
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
