description: This cmdlet dumps the current configuration and state of Network Controller
  services on the local Network Controller nodes
synopses:
- Invoke-NetworkControllerState [[-Tags] <PSObject>] [-Properties] <NetworkControllerStateProperties>
  [[-Etag] <String>] [[-ResourceMetadata] <ResourceMetadata>] [[-ResourceId] <String>]
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
  -Properties NetworkControllerStateProperties:
    required: true
  -ResourceId string: ~
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
