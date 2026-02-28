description: Gets an Active Directory forest
synopses:
- Get-ADForest [-AuthType <ADAuthType>] [-Credential <PSCredential>] [-Current <ADCurrentForestType>]
  [-Server <String>] [<CommonParameters>]
- Get-ADForest [-AuthType <ADAuthType>] [-Credential <PSCredential>] [-Identity] <ADForest>
  [-Server <String>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Credential PSCredential: ~
  -Current ADCurrentForestType:
    values:
    - LocalComputer
    - LoggedOnUser
  -Identity ADForest:
    required: true
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
