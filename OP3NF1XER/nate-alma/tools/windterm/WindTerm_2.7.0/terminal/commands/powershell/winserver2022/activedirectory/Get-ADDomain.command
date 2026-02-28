description: Gets an Active Directory domain
synopses:
- Get-ADDomain [-AuthType <ADAuthType>] [-Credential <PSCredential>] [-Current <ADCurrentDomainType>]
  [-Server <String>] [<CommonParameters>]
- Get-ADDomain [-AuthType <ADAuthType>] [-Credential <PSCredential>] [-Identity] <ADDomain>
  [-Server <String>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Credential PSCredential: ~
  -Current ADCurrentDomainType:
    values:
    - LocalComputer
    - LoggedOnUser
  -Identity ADDomain:
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
