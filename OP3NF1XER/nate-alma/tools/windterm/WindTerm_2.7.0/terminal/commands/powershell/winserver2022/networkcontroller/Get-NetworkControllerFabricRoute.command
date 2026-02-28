description: Gets the routes specified for logical subnet children of the logical
  network objects
synopses:
- Get-NetworkControllerFabricRoute [-LogicalNetworkId] <String[]> [-SubnetId] <String[]>
  [[-ResourceId] <String[]>] -ConnectionUri <Uri> [-CertificateThumbprint <String>]
  [-Credential <PSCredential>] [-PassInnerException] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -ConnectionUri Uri:
    required: true
  -Credential PSCredential: ~
  -LogicalNetworkId String[]:
    required: true
  -PassInnerException Switch: ~
  -ResourceId String[]: ~
  -SubnetId String[]:
    required: true
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
