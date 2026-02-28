description: Modifies a pre-staged client device
synopses:
- Set-WdsClient [-Group <String>] [-ReferralServer <String>] [-PxePromptPolicy <PxePromptPolicy>]
  [-WdsClientUnattend <String>] [-JoinDomain <Boolean>] [-ResetAccount] [-DeviceID
  <String>] [-BootImagePath <String>] -DeviceName <String> [-SearchForest] -User <String>
  -JoinRights <JoinRights> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Set-WdsClient [-Group <String>] [-ReferralServer <String>] [-PxePromptPolicy <PxePromptPolicy>]
  [-WdsClientUnattend <String>] [-JoinDomain <Boolean>] [-ResetAccount] [-DeviceID
  <String>] [-BootImagePath <String>] -DeviceName <String> [-DomainName <String>]
  [-Domain] -User <String> -JoinRights <JoinRights> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Set-WdsClient [-Group <String>] [-ReferralServer <String>] [-PxePromptPolicy <PxePromptPolicy>]
  [-WdsClientUnattend <String>] [-JoinDomain <Boolean>] [-ResetAccount] [-DeviceID
  <String>] [-BootImagePath <String>] -DeviceName <String> -User <String> -JoinRights
  <JoinRights> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-WdsClient [-Group <String>] [-ReferralServer <String>] [-PxePromptPolicy <PxePromptPolicy>]
  [-WdsClientUnattend <String>] [-JoinDomain <Boolean>] [-ResetAccount] [-DeviceID
  <String>] [-BootImagePath <String>] -DeviceName <String> [-SearchForest] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-WdsClient [-Group <String>] [-ReferralServer <String>] [-PxePromptPolicy <PxePromptPolicy>]
  [-WdsClientUnattend <String>] [-JoinDomain <Boolean>] [-ResetAccount] [-DeviceID
  <String>] [-BootImagePath <String>] -DeviceName <String> [-DomainName <String>]
  [-Domain] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-WdsClient [-Group <String>] [-ReferralServer <String>] [-PxePromptPolicy <PxePromptPolicy>]
  [-WdsClientUnattend <String>] [-JoinDomain <Boolean>] [-ResetAccount] [-DeviceID
  <String>] [-BootImagePath <String>] -DeviceName <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BootImagePath String: ~
  -CimSession,-Session CimSession[]: ~
  -DeviceID String: ~
  -DeviceName String:
    required: true
  -Domain Switch:
    required: true
  -DomainName String: ~
  -Group String: ~
  -JoinDomain Boolean: ~
  -JoinRights JoinRights:
    required: true
    values:
    - JoinOnly
    - Full
  -PxePromptPolicy PxePromptPolicy:
    values:
    - OptIn
    - NoPrompt
    - OptOut
    - Abort
  -ReferralServer String: ~
  -ResetAccount Switch: ~
  -SearchForest Switch:
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
