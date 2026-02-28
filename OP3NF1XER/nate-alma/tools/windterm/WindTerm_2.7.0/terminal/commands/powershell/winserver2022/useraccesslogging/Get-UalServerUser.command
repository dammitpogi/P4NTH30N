description: Gets UAL records for a server per user
synopses:
- Get-UalServerUser [-ChassisSerialNumber <String[]>] [-UUID <String[]>] [-Username
  <String[]>] [-ActivityCount <UInt32[]>] [-FirstSeen <DateTime[]>] [-LastSeen <DateTime[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -ActivityCount UInt32[]: ~
  -AsJob Switch: ~
  -ChassisSerialNumber String[]: ~
  -CimSession,-Session CimSession[]: ~
  -FirstSeen DateTime[]: ~
  -LastSeen DateTime[]: ~
  -ThrottleLimit Int32: ~
  -UUID String[]: ~
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
