description: Gets VIP host mapping
synopses:
- Get-VipHostMapping [-NetworkController] <String> [[-Credential] <PSCredential>]
  [-RestURI] <String> [[-CertificateThumbprint] <String>] [-VipEndPoint] <String>
  [-Type] <String> [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -Credential PSCredential: ~
  -NetworkController String:
    required: true
  -RestURI String:
    required: true
  -Type String:
    required: true
    values:
    - L3Nat
    - InboundNatRule
    - LoadBalancingRule
    - OutboundNatRule
  -VipEndPoint String:
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
