description: This cmdlet removes an IP pool from a network
synopses:
- Remove-NetworkControllerIpPool [-NetworkId] <String> [-SubnetId] <String> [-ResourceId]
  <String> [[-Etag] <String>] [-Force] -ConnectionUri <Uri> [-CertificateThumbprint
  <String>] [-Credential <PSCredential>] [-PassInnerException] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CertificateThumbPrint string: ~
  -ConnectionUri Uri:
    required: true
  -Credential PSCredential: ~
  -Etag string: ~
  -Force Switch: ~
  -NetworkId string:
    required: true
  -PassInnerException Switch: ~
  -ResourceId string:
    required: true
  -SubnetId string:
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
