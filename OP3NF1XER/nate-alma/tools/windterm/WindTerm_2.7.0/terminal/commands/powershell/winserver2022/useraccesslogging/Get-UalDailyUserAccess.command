description: Gets UAL records for client requests per user for each day
synopses:
- Get-UalDailyUserAccess [-ProductName <String[]>] [-RoleName <String[]>] [-RoleGuid
  <String[]>] [-Username <String[]>] [-AccessDate <DateTime[]>] [-AccessCount <UInt32[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AccessCount UInt32[]: ~
  -AccessDate DateTime[]: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ProductName String[]: ~
  -RoleGuid String[]: ~
  -RoleName String[]: ~
  -ThrottleLimit Int32: ~
  -Username String[]: ~
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
