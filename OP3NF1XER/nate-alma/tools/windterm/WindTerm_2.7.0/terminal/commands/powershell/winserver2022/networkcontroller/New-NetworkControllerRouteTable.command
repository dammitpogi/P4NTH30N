description: This cmdlet creates a new route table in the Network Controller
synopses:
- New-NetworkControllerRouteTable [-ResourceId] <String> [[-Tags] <PSObject>] [-Properties]
  <RouteTableProperties> [[-Etag] <String>] [[-ResourceMetadata] <ResourceMetadata>]
  [-Force] -ConnectionUri <Uri> [-CertificateThumbprint <String>] [-Credential <PSCredential>]
  [-PassInnerException] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateThumbPrint string: ~
  -ConnectionUri Uri:
    required: true
  -Credential PSCredential: ~
  -Etag string: ~
  -Force Switch: ~
  -PassInnerException Switch: ~
  -Properties RouteTableProperties:
    required: true
  -ResourceId string:
    required: true
  -ResourceMetadata ResourceMetadata: ~
  -Tags psobject: ~
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
