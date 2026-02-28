description: Removes a local node from a Host Guardian Service and from the domain
synopses:
- Uninstall-HgsServer [-LocalAdministratorPassword] <SecureString> [-HgsDomainCredential
  <PSCredential>] [-Force] [-Restart] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Force Switch: ~
  -HgsDomainCredential PSCredential: ~
  -LocalAdministratorPassword SecureString:
    required: true
  -Restart Switch: ~
  -Confirm,-cf Switch: ~
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
