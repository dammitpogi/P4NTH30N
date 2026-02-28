description: Uninstalls specified Windows Server roles, role services, and features
  from a computer that is running Windows Server 2012 R2
synopses:
- Uninstall-WindowsFeature [-Name] <Feature[]> [-Restart] [-IncludeManagementTools]
  [-Remove] [-ComputerName <String>] [-Credential <PSCredential>] [-LogPath <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Uninstall-WindowsFeature [-Name] <Feature[]> [-Vhd <String>] [-IncludeManagementTools]
  [-Remove] [-ComputerName <String>] [-Credential <PSCredential>] [-LogPath <String>]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -IncludeManagementTools Switch: ~
  -LogPath String: ~
  -Name Feature[]:
    required: true
  -Remove Switch: ~
  -Restart Switch: ~
  -Vhd String: ~
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
