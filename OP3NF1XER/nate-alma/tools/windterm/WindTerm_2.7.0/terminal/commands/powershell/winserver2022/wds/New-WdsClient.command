description: Creates a pre-staged client
synopses:
- New-WdsClient [-Group <String>] [-ReferralServer <String>] [-PxePromptPolicy <PxePromptPolicy>]
  [-WdsClientUnattend <String>] [-JoinDomain <Boolean>] [-BootImagePath <String>]
  [-OU <String>] [-Domain <String>] -DeviceID <String> -DeviceName <String> -User
  <String> -JoinRights <JoinRights> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- New-WdsClient [-Group <String>] [-ReferralServer <String>] [-PxePromptPolicy <PxePromptPolicy>]
  [-WdsClientUnattend <String>] [-JoinDomain <Boolean>] [-BootImagePath <String>]
  [-OU <String>] [-Domain <String>] -DeviceID <String> -DeviceName <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BootImagePath String: ~
  -CimSession,-Session CimSession[]: ~
  -DeviceID String:
    required: true
  -DeviceName String:
    required: true
  -Domain String: ~
  -Group String: ~
  -JoinDomain Boolean: ~
  -JoinRights JoinRights:
    required: true
    values:
    - JoinOnly
    - Full
  -OU String: ~
  -PxePromptPolicy PxePromptPolicy:
    values:
    - OptIn
    - NoPrompt
    - OptOut
    - Abort
  -ReferralServer String: ~
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
