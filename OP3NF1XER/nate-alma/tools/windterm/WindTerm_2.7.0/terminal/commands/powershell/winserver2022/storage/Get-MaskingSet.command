description: Gets masking sets. Masking sets are used to grant access to a virtual
  disk or iSCSI VHD for one or more servers
synopses:
- Get-MaskingSet [[-FriendlyName] <String[]>] [-HostType <HostType[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-MaskingSet [-UniqueId <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-MaskingSet [-TargetPort <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-MaskingSet [-InitiatorId <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-MaskingSet [-StorageSubSystem <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-MaskingSet [-VirtualDisk <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -FriendlyName String[]: ~
  -HostType HostType[]:
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
  -InitiatorId CimInstance: ~
  -StorageSubSystem CimInstance: ~
  -TargetPort CimInstance: ~
  -ThrottleLimit Int32: ~
  -UniqueId,-Id String[]: ~
  -VirtualDisk CimInstance: ~
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
