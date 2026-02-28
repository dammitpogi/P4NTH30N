description: This cmdlet retrieves the settings of a virtual network from the Network
  Controller
synopses:
- Get-NetworkControllerVirtualNetwork [[-ResourceId] <String[]>] -ConnectionUri <Uri>
  [-CertificateThumbprint <String>] [-Credential <PSCredential>] [-PassInnerException]
  [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -ConnectionUri Uri:
    required: true
  -Credential PSCredential: ~
  -PassInnerException Switch: ~
  -ResourceId String[]: ~
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
