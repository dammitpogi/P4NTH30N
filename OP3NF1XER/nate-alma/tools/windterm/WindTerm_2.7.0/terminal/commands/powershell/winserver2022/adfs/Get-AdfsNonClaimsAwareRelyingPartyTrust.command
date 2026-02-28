description: Gets the properties of a relying party trust for a non-claims-aware web
  application or service
synopses:
- Get-AdfsNonClaimsAwareRelyingPartyTrust [<CommonParameters>]
- Get-AdfsNonClaimsAwareRelyingPartyTrust -TargetIdentifier <String> [<CommonParameters>]
- Get-AdfsNonClaimsAwareRelyingPartyTrust [-TargetName] <String> [<CommonParameters>]
- Get-AdfsNonClaimsAwareRelyingPartyTrust -TargetNonClaimsAwareRelyingPartyTrust <NonClaimsAwareRelyingPartyTrust>
  [<CommonParameters>]
options:
  -TargetIdentifier String:
    required: true
  -TargetName String:
    required: true
  -TargetNonClaimsAwareRelyingPartyTrust NonClaimsAwareRelyingPartyTrust:
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
