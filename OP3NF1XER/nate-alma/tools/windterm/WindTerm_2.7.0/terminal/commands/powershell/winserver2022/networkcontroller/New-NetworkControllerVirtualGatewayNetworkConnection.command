description: Creates a virtual gateway network connection
synopses:
- New-NetworkControllerVirtualGatewayNetworkConnection [-VirtualGatewayId] <String>
  [-ResourceId] <String> [-Properties] <NetworkConnectionProperties> [[-ResourceMetadata]
  <ResourceMetadata>] [[-Etag] <String>] [-Force] -ConnectionUri <Uri> [-CertificateThumbprint
  <String>] [-Credential <PSCredential>] [-PassInnerException] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -Confirm,-cf Switch: ~
  -ConnectionUri Uri:
    required: true
  -Credential PSCredential: ~
  -Etag String: ~
  -Force Switch: ~
  -PassInnerException Switch: ~
  -Properties NetworkConnectionProperties:
    required: true
  -ResourceId String:
    required: true
  -ResourceMetadata ResourceMetadata: ~
  -VirtualGatewayId String:
    required: true
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
