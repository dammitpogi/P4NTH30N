description: Removes a pre-staged client from AD DS or the stand-alone server device
  database, or clears the Pending Devices database
synopses:
- Remove-WdsClient -DeviceName <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Remove-WdsClient -PendingClientStatus <PendingClientStatusFlag> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Remove-WdsClient -DeviceID <String> [-SearchForest] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Remove-WdsClient -DeviceID <String> [-DomainName <String>] [-Domain] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Remove-WdsClient -DeviceID <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Remove-WdsClient [-DomainName <String>] [-Domain] -DeviceName <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Remove-WdsClient [-SearchForest] -DeviceName <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DeviceID String:
    required: true
  -DeviceName String:
    required: true
  -Domain Switch:
    required: true
  -DomainName String: ~
  -PendingClientStatus PendingClientStatusFlag:
    required: true
    values:
    - Pending
    - Approved
    - Denied
    - Any
  -SearchForest Switch:
    required: true
  -ThrottleLimit Int32: ~
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
