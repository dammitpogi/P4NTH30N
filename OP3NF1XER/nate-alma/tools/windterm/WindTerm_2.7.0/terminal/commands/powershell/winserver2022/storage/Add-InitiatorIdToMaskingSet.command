description: Adds an initiator ID to an existing masking set, granting the host associated
  with the initiator ID access to the virtual disk and target port resources defined
  in the masking set
synopses:
- Add-InitiatorIdToMaskingSet [-MaskingSetFriendlyName] <String[]> [-InitiatorIds
  <String[]>] [-HostType <HostType>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-InitiatorIdToMaskingSet -MaskingSetUniqueId <String[]> [-InitiatorIds <String[]>]
  [-HostType <HostType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-InitiatorIdToMaskingSet -InputObject <CimInstance[]> [-InitiatorIds <String[]>]
  [-HostType <HostType>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
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
  -InitiatorIds String[]: ~
  -InputObject CimInstance[]:
    required: true
  -MaskingSetFriendlyName String[]:
    required: true
  -MaskingSetUniqueId,-Id String[]:
    required: true
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
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
