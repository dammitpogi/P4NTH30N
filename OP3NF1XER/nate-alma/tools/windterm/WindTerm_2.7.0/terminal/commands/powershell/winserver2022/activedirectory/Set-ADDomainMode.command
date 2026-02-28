description: Sets the domain mode for an Active Directory domain
synopses:
- Set-ADDomainMode [-WhatIf] [-Confirm] [-AuthType <ADAuthType>] [-Credential <PSCredential>]
  [-DomainMode] <ADDomainMode> [-Identity] <ADDomain> [-PassThru] [-Server <String>]
  [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -DomainMode ADDomainMode:
    required: true
    values:
    - Windows2000Domain
    - Windows2003InterimDomain
    - Windows2003Domain
    - Windows2008Domain
    - Windows2008R2Domain
    - Windows2012Domain
    - Windows2012R2Domain
    - Windows2016Domain
    - UnknownDomain
  -Identity ADDomain:
    required: true
  -PassThru Switch: ~
  -Server String: ~
  -WhatIf,-wi Switch: ~
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
