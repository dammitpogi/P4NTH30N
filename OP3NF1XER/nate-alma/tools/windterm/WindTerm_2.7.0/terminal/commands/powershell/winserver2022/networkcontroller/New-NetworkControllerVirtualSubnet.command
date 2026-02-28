description: This cmdlet creates a new virtual subnet in a virtual network, or updates
  a virtual subnet in a virtual network
synopses:
- New-NetworkControllerVirtualSubnet [-VirtualNetworkId] <String> [-ResourceId] <String>
  [-Properties] <VirtualSubnetProperties> [[-ResourceMetadata] <ResourceMetadata>]
  [[-Etag] <String>] [-Force] -ConnectionUri <Uri> [-CertificateThumbprint <String>]
  [-Credential <PSCredential>] [-PassInnerException] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateThumbPrint string: ~
  -ConnectionUri Uri:
    required: true
  -Credential PSCredential: ~
  -Etag string: ~
  -Force Switch: ~
  -PassInnerException Switch: ~
  -Properties VirtualSubnetProperties:
    required: true
  -ResourceId string:
    required: true
  -ResourceMetadata ResourceMetadata: ~
  -VirtualNetworkId string:
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
