description: Starts, stops, and suspends a service, and changes its properties
synopses:
- Set-Service [-Name] <String> [-DisplayName <String>] [-Credential <PSCredential>]
  [-Description <String>] [-StartupType <ServiceStartupType>] [-Status <String>] [-SecurityDescriptorSddl
  <String>] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-Service [-InputObject] <ServiceController> [-DisplayName <String>] [-Credential
  <PSCredential>] [-Description <String>] [-StartupType <ServiceStartupType>] [-SecurityDescriptorSddl
  <String>] [-Status <String>] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Description System.String: ~
  -DisplayName,-DN System.String: ~
  -Force Switch: ~
  -InputObject System.ServiceProcess.ServiceController:
    required: true
  -Name,-ServiceName,-SN System.String:
    required: true
  -PassThru Switch: ~
  -SecurityDescriptorSddl,-sd System.String: ~
  -StartupType,-StartMode,-SM,-ST,-StartType Microsoft.PowerShell.Commands.ServiceStartupType:
    values:
    - Automatic
    - AutomaticDelayedStart
    - Disabled
    - InvalidValue
    - Manual
  -Status System.String:
    values:
    - Paused
    - Running
    - Stopped
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
