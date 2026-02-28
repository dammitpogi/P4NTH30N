description: Revokes permissions to security principals for a replication group
synopses:
- Revoke-DfsrDelegation [-GroupName] <String[]> [-AccountName] <String[]> [-Force]
  [[-DomainName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AccountName String[]:
    required: true
  -Confirm,-cf Switch: ~
  -DomainName String: ~
  -Force Switch: ~
  -GroupName,-RG,-RgName String[]:
    required: true
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
