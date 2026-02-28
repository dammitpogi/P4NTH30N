description: Returns one or more Active Directory claim transform objects based on
  a specified filter
synopses:
- Get-ADClaimTransformPolicy [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  -Filter <String> [-Properties <String[]>] [-Server <String>] [<CommonParameters>]
- Get-ADClaimTransformPolicy [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  [[-Identity] <ADClaimTransformPolicy>] [-Properties <String[]>] [-Server <String>]
  [<CommonParameters>]
- Get-ADClaimTransformPolicy [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  -LDAPFilter <String> [-Properties <String[]>] [-Server <String>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Credential PSCredential: ~
  -Filter String:
    required: true
  -Identity ADClaimTransformPolicy: ~
  -LDAPFilter String:
    required: true
  -Properties,-Property String[]: ~
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
