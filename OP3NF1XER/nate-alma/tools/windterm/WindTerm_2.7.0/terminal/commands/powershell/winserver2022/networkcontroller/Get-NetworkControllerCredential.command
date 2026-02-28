description: Retrieves a specified device credential or all device credentials from
  Network Controller
synopses:
- Get-NetworkControllerCredential [[-ResourceId] <String[]>] -ConnectionUri <Uri>
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
