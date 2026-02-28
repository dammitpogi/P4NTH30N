description: Gets a BGP peer
synopses:
- Get-NetworkControllerVirtualGatewayBgpPeer [-VirtualGatewayId] <String[]> [-BgpRouterName]
  <String[]> [[-ResourceId] <String[]>] -ConnectionUri <Uri> [-CertificateThumbprint
  <String>] [-Credential <PSCredential>] [-PassInnerException] [<CommonParameters>]
options:
  -BgpRouterName String[]:
    required: true
  -CertificateThumbprint String: ~
  -ConnectionUri Uri:
    required: true
  -Credential PSCredential: ~
  -PassInnerException Switch: ~
  -ResourceId String[]: ~
  -VirtualGatewayId String[]:
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
