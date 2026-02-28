description: Gets the relying party trusts of the Federation Service
synopses:
- Get-AdfsRelyingPartyTrust [[-Name] <String[]>] [<CommonParameters>]
- Get-AdfsRelyingPartyTrust [-Identifier] <String[]> [<CommonParameters>]
- Get-AdfsRelyingPartyTrust [-PrefixIdentifier] <String> [<CommonParameters>]
options:
  -Identifier String[]:
    required: true
  -Name String[]: ~
  -PrefixIdentifier String:
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
