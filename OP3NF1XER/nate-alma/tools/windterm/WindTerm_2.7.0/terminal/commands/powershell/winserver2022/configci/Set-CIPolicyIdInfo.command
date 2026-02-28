description: Modifies the name and ID of a Code Integrity policy
synopses:
- Set-CIPolicyIdInfo [-FilePath] <String> [-PolicyName <String>] [-SupplementsBasePolicyID
  <Guid>] [-BasePolicyToSupplementPath <String>] [-ResetPolicyID] [-PolicyId <String>]
  [<CommonParameters>]
options:
  -BasePolicyToSupplementPath String: ~
  -FilePath,-f String:
    required: true
  -PolicyId,-pid String: ~
  -PolicyName,-pn String: ~
  -ResetPolicyID Switch: ~
  -SupplementsBasePolicyID,-None Guid: ~
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
