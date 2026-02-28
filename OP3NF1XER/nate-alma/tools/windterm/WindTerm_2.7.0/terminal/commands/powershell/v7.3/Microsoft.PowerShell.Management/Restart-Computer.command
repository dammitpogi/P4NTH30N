description: Restarts the operating system on local and remote computers
synopses:
- Restart-Computer [-WsmanAuthentication <String>] [[-ComputerName] <String[]>] [[-Credential]<PSCredential>]
  [-Force] [-Wait] [-Timeout <Int32>] [-For <WaitForServiceTypes>] [-Delay <Int16>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ComputerName,-CN,-__SERVER,-Server,-IPAddress System.String[]: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Delay System.Int16: ~
  -For Microsoft.PowerShell.Commands.WaitForServiceTypes:
    values:
    - Wmi
    - WinRM
    - PowerShell
  -Force,-f Switch: ~
  -Timeout,-TimeoutSec System.Int32: ~
  -Wait Switch: ~
  -WsmanAuthentication System.String:
    values:
    - Basic
    - CredSSP
    - Default
    - Digest
    - Kerberos
    - Negotiate
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
