description: Installs one or more roles, role services, or features on either the
  local or a specified remote server that is running Windows Server 2012 R2
synopses:
- Install-WindowsFeature [-Name] <Feature[]> [-Restart] [-IncludeAllSubFeature] [-IncludeManagementTools]
  [-Source <String[]>] [-ComputerName <String>] [-Credential <PSCredential>] [-LogPath
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Install-WindowsFeature [-Name] <Feature[]> -Vhd <String> [-IncludeAllSubFeature]
  [-IncludeManagementTools] [-Source <String[]>] [-ComputerName <String>] [-Credential
  <PSCredential>] [-LogPath <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Install-WindowsFeature -ConfigurationFilePath <String> [-Vhd <String>] [-Restart]
  [-Source <String[]>] [-ComputerName <String>] [-Credential <PSCredential>] [-LogPath
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ComputerName,-Cn String: ~
  -ConfigurationFilePath String:
    required: true
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -IncludeAllSubFeature Switch: ~
  -IncludeManagementTools Switch: ~
  -LogPath String: ~
  -Name Feature[]:
    required: true
  -Restart Switch: ~
  -Source String[]: ~
  -Vhd String:
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
