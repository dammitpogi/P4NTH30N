description: Queries the Network Controller for REST information
synopses:
- Get-NetworkControllerDeploymentInfo [-NetworkController] <String> [[-Credential]
  <PSCredential>] [[-RestURI] <String>] [[-CertificateThumbprint] <String>] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -Credential PSCredential: ~
  -NetworkController String:
    required: true
  -RestURI String: ~
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
