description: Makes a virtual disk available to a host
synopses:
- Show-VirtualDisk [-FriendlyName] <String[]> [-TargetPortAddresses <String[]>] [-InitiatorAddress
  <String>] [-HostType <HostType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Show-VirtualDisk -UniqueId <String[]> [-TargetPortAddresses <String[]>] [-InitiatorAddress
  <String>] [-HostType <HostType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Show-VirtualDisk -Name <String[]> [-TargetPortAddresses <String[]>] [-InitiatorAddress
  <String>] [-HostType <HostType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Show-VirtualDisk -InputObject <CimInstance[]> [-TargetPortAddresses <String[]>]
  [-InitiatorAddress <String>] [-HostType <HostType>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -FriendlyName String[]:
    required: true
  -HostType HostType:
    values:
    - Unknown
    - Other
    - Standard
    - Solaris
    - HPUX
    - OpenVMS
    - Tru64
    - Netware
    - Sequent
    - AIX
    - DGUX
    - Dynix
    - Irix
    - CiscoISCSIStorageRouter
    - Linux
    - MicrosoftWindows
    - OS400
    - TRESPASS
    - HIUX
    - VMwareESXi
    - MicrosoftWindowsServer2008
    - MicrosoftWindowsServer2003
  -InitiatorAddress String: ~
  -InputObject CimInstance[]:
    required: true
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -TargetPortAddresses String[]: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String[]:
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
