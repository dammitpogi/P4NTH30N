description: Renames a computer
synopses:
- Rename-Computer [-ComputerName <String>] [-PassThru] [-DomainCredential <PSCredential>]
  [-LocalCredential <PSCredential>] [-NewName] <String> [-Force] [-Restart] [-WsmanAuthentication
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ComputerName System.String: ~
  -DomainCredential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
  -LocalCredential System.Management.Automation.PSCredential: ~
  -NewName System.String:
    required: true
  -PassThru Switch: ~
  -Restart Switch: ~
  -WsmanAuthentication System.String:
    values:
    - Default
    - Basic
    - Negotiate
    - CredSSP
    - Digest
    - Kerberos
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
