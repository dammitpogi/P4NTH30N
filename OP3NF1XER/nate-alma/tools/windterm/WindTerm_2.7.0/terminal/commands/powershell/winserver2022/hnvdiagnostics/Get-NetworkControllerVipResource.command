description: Gets a VIP resource
synopses:
- Get-NetworkControllerVipResource [[-RestURI] <String>] [[-CertificateThumbprint]
  <String>] [[-Credential] <PSCredential>] [[-Direction] <String>] [-IPAddress] <String>
  [[-DstPort] <String>] [[-Protocol] <String>] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -Credential PSCredential: ~
  -Direction String:
    values:
    - Out
    - In
  -DstPort String: ~
  -IPAddress String:
    required: true
  -Protocol String:
    values:
    - Tcp
    - Udp
    - All
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
