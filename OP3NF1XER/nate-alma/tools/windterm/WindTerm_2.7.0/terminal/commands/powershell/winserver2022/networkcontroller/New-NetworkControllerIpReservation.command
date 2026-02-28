description: Creates an IP reservation for a subnet in Network Controller
synopses:
- New-NetworkControllerIpReservation [-NetworkId] <String> [-SubnetId] <String> [-ResourceId]
  <String> [-Properties] <IpReservationProperties> [[-ResourceMetadata] <ResourceMetadata>]
  [[-Etag] <String>] [-Force] -ConnectionUri <Uri> [-CertificateThumbprint <String>]
  [-Credential <PSCredential>] [-PassInnerException] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -ConnectionUri Uri:
    required: true
  -Credential PSCredential: ~
  -Etag String: ~
  -Force Switch: ~
  -NetworkId String:
    required: true
  -PassInnerException Switch: ~
  -Properties IpReservationProperties:
    required: true
  -ResourceId String:
    required: true
  -ResourceMetadata ResourceMetadata: ~
  -SubnetId String:
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
