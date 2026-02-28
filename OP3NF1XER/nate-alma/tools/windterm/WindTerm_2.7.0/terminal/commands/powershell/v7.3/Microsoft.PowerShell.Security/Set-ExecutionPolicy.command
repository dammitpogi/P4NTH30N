description: Sets the PowerShell execution policies for Windows computers
synopses:
- Set-ExecutionPolicy [-ExecutionPolicy] <ExecutionPolicy> [[-Scope] <ExecutionPolicyScope>]
  [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ExecutionPolicy Microsoft.PowerShell.ExecutionPolicy:
    required: true
    values:
    - AllSigned
    - Bypass
    - Default
    - RemoteSigned
    - Restricted
    - Undefined
    - Unrestricted
  -Force Switch: ~
  -Scope Microsoft.PowerShell.ExecutionPolicyScope:
    values:
    - CurrentUser
    - LocalMachine
    - MachinePolicy
    - Process
    - UserPolicy
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
