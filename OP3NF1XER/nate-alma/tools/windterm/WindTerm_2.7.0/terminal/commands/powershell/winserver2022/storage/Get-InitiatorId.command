description: Gets the InitiatorID objects for the specified iSCSI initiators
synopses:
- Get-InitiatorId [[-InitiatorAddress] <String[]>] [-HostType <HostType[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-InitiatorId [-UniqueId <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-InitiatorId [-MaskingSet <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-InitiatorId [-VirtualDisk <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-InitiatorId [-StorageSubSystem <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
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
  -InitiatorAddress String[]: ~
  -MaskingSet CimInstance: ~
  -StorageSubSystem CimInstance: ~
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
