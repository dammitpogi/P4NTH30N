description: Stops (shuts down) local and remote computers
synopses:
- Stop-Computer [-WsmanAuthentication <String>] [[-ComputerName] <String[]>] [[-Credential]
  <PSCredential>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ComputerName,-CN,-__SERVER,-Server,-IPAddress System.String[]: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Force Switch: ~
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
