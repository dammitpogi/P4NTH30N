description: Gets UAL information about virtual machines
synopses:
- Get-UalHyperV [-ProductName <String[]>] [-RoleName <String[]>] [-RoleGuid <String[]>]
  [-UUID <String[]>] [-ChassisSerialNumber <String[]>] [-FirstSeen <DateTime[]>] [-LastSeen
  <DateTime[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -ChassisSerialNumber String[]: ~
  -CimSession,-Session CimSession[]: ~
  -FirstSeen DateTime[]: ~
  -LastSeen DateTime[]: ~
  -ProductName String[]: ~
  -RoleGuid String[]: ~
  -RoleName String[]: ~
  -ThrottleLimit Int32: ~
  -UUID String[]: ~
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
