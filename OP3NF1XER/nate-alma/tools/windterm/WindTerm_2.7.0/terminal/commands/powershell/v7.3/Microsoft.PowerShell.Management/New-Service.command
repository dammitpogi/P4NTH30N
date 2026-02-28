description: Creates a new Windows service
synopses:
- New-Service [-Name] <String> [-BinaryPathName] <String> [-DisplayName <String>]
  [-Description <String>] [-SecurityDescriptorSddl <String>] [-StartupType <ServiceStartupType>]
  [-Credential <PSCredential>] [-DependsOn <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -BinaryPathName,-Path System.String:
    required: true
  -Credential System.Management.Automation.PSCredential: ~
  -DependsOn System.String[]: ~
  -Description System.String: ~
  -DisplayName System.String: ~
  -Name,-ServiceName System.String:
    required: true
  -SecurityDescriptorSddl,-sd System.String: ~
  -StartupType Microsoft.PowerShell.Commands.ServiceStartupType:
    values:
    - Automatic
    - Manual
    - Disabled
    - AutomaticDelayedStart
    - InvalidValue
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
