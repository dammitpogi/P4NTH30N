description: Gets one or more Active Directory Domain Services authentication policy
  silos
synopses:
- Get-ADAuthenticationPolicySilo [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  -Filter <String> [-Properties <String[]>] [-ResultPageSize <Int32>] [-ResultSetSize
  <Int32>] [-Server <String>] [<CommonParameters>]
- Get-ADAuthenticationPolicySilo [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  [-Identity] <ADAuthenticationPolicySilo> [-Properties <String[]>] [-Server <String>]
  [<CommonParameters>]
- Get-ADAuthenticationPolicySilo [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  -LDAPFilter <String> [-Properties <String[]>] [-ResultPageSize <Int32>] [-ResultSetSize
  <Int32>] [-Server <String>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Credential PSCredential: ~
  -Filter String:
    required: true
  -Identity ADAuthenticationPolicySilo:
    required: true
  -LDAPFilter String:
    required: true
  -Properties,-Property String[]: ~
  -ResultPageSize Int32: ~
  -ResultSetSize Int32: ~
  -Server String: ~
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
