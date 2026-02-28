description: Gets the claims provider trusts in the Federation Service
synopses:
- Get-AdfsClaimsProviderTrust [[-Name] <String[]>] [<CommonParameters>]
- Get-AdfsClaimsProviderTrust [-Certificate] <X509Certificate2[]> [<CommonParameters>]
- Get-AdfsClaimsProviderTrust [-Identifier] <String[]> [<CommonParameters>]
options:
  -Certificate X509Certificate2[]:
    required: true
  -Identifier String[]:
    required: true
  -Name String[]: ~
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
