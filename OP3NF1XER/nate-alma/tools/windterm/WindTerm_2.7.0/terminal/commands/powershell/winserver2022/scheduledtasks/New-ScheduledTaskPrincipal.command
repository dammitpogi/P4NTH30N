description: Creates an object that contains a scheduled task principal
synopses:
- New-ScheduledTaskPrincipal [[-Id] <String>] [[-RunLevel] <RunLevelEnum>] [[-ProcessTokenSidType]
  <ProcessTokenSidTypeEnum>] [[-RequiredPrivilege] <String[]>] [-UserId] <String>
  [[-LogonType] <LogonTypeEnum>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- New-ScheduledTaskPrincipal [-GroupId] <String> [[-Id] <String>] [[-RunLevel] <RunLevelEnum>]
  [[-ProcessTokenSidType] <ProcessTokenSidTypeEnum>] [[-RequiredPrivilege] <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -GroupId String:
    required: true
  -Id String: ~
  -LogonType LogonTypeEnum:
    values:
    - None
    - Password
    - S4U
    - Interactive
    - Group
    - ServiceAccount
    - InteractiveOrPassword
  -ProcessTokenSidType ProcessTokenSidTypeEnum:
    values:
    - None
    - Unrestricted
    - Default
  -RequiredPrivilege String[]: ~
  -RunLevel RunLevelEnum:
    values:
    - Limited
    - Highest
  -ThrottleLimit Int32: ~
  -UserId String:
    required: true
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
