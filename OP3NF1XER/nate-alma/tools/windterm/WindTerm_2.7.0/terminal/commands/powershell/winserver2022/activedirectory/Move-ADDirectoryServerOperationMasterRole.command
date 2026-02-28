description: Moves operation master roles to an Active Directory directory server
synopses:
- Move-ADDirectoryServerOperationMasterRole [-WhatIf] [-Confirm] [-AuthType <ADAuthType>]
  [-Credential <PSCredential>] [-Force] [-Identity] <ADDirectoryServer> [-OperationMasterRole]
  <ADOperationMasterRole[]> [-PassThru] [-Server <String>] [<CommonParameters>]
options:
  -AuthType ADAuthType:
    values:
    - Negotiate
    - Basic
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -Force Switch: ~
  -Identity ADDirectoryServer:
    required: true
  -OperationMasterRole ADOperationMasterRole[]:
    required: true
    values:
    - PDCEmulator
    - RIDMaster
    - InfrastructureMaster
    - SchemaMaster
    - DomainNamingMaster
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
