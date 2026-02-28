description: Approves clients
synopses:
- Approve-WdsClient [-BootImagePath <String>] [-BootProgram <String>] [-JoinDomain
  <Boolean>] [-OU <String>] [-ReferralServer <String>] [-WdsClientUnattend <String>]
  -JoinRights <JoinRights> -User <String> [-DeviceName <String>] -RequestId <UInt32>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Approve-WdsClient [-BootImagePath <String>] [-BootProgram <String>] [-JoinDomain
  <Boolean>] [-OU <String>] [-ReferralServer <String>] [-WdsClientUnattend <String>]
  [-DeviceName <String>] -RequestId <UInt32> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Approve-WdsClient [-BootImagePath <String>] [-BootProgram <String>] [-JoinDomain
  <Boolean>] [-OU <String>] [-ReferralServer <String>] [-WdsClientUnattend <String>]
  -JoinRights <JoinRights> -User <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Approve-WdsClient [-BootImagePath <String>] [-BootProgram <String>] [-JoinDomain
  <Boolean>] [-OU <String>] [-ReferralServer <String>] [-WdsClientUnattend <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BootImagePath String: ~
  -BootProgram String: ~
  -CimSession,-Session CimSession[]: ~
  -DeviceName String: ~
  -JoinDomain Boolean: ~
  -JoinRights JoinRights:
    required: true
    values:
    - JoinOnly
    - Full
  -OU String: ~
  -ReferralServer String: ~
  -RequestId UInt32:
    required: true
  -ThrottleLimit Int32: ~
  -User String:
    required: true
  -WdsClientUnattend String: ~
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
