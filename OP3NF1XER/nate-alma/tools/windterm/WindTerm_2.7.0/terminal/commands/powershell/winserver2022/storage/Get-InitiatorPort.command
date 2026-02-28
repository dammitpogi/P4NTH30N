description: Gets one or more host bus adapter (HBA) initiator ports
synopses:
- Get-InitiatorPort [[-NodeAddress] <String[]>] [-ConnectionType <ConnectionType[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-InitiatorPort [-ObjectId <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-InitiatorPort [-InstanceName <String[]>] [-ConnectionType <ConnectionType[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-InitiatorPort [-VirtualDisk <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-InitiatorPort [-iSCSISession <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-InitiatorPort [-iSCSIConnection <CimInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-InitiatorPort [-iSCSITarget <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ConnectionType ConnectionType[]:
    values:
    - Other
    - FibreChannel
    - iSCSI
    - SAS
  -InstanceName String[]: ~
  -NodeAddress String[]: ~
  -ObjectId,-Id String[]: ~
  -ThrottleLimit Int32: ~
  -VirtualDisk CimInstance: ~
  -iSCSIConnection CimInstance: ~
  -iSCSISession CimInstance: ~
  -iSCSITarget CimInstance: ~
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
