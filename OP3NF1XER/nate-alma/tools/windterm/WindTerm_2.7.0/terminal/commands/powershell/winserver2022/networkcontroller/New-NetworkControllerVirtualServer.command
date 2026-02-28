description: Adds a new virtual server to the Network Controller. If already present,
  updates the properties of the virtual server
synopses:
- New-NetworkControllerVirtualServer [-ResourceId] <String> [-MarkServerReadOnly]
  <Boolean> [[-Tags] <PSObject>] [-Properties] <VirtualServerProperties> [[-Etag]
  <String>] [[-ResourceMetadata] <ResourceMetadata>] [-Force] -ConnectionUri <Uri>
  [-CertificateThumbprint <String>] [-Credential <PSCredential>] [-PassInnerException]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateThumbPrint string: ~
  -ConnectionUri Uri:
    required: true
  -Credential PSCredential: ~
  -Etag string: ~
  -Force Switch: ~
  -MarkServerReadOnly Boolean:
    required: true
  -PassInnerException Switch: ~
  -Properties VirtualServerProperties:
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
