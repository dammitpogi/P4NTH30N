description: Gets the details of events generated in a Server Manager event log
synopses:
- Get-SMServerEvent [-Log <String[]>] [-Level <EventLevelFlag[]>] [-StartTime <UInt64[]>]
  [-EndTime <UInt64[]>] [-BatchSize <UInt32>] [-QueryFile <String[]>] [-QueryFileId
  <Int32[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BatchSize UInt32: ~
  -CimSession,-Session CimSession[]: ~
  -EndTime UInt64[]: ~
  -Level EventLevelFlag[]:
    values:
    - Critical
    - Error
    - Warning
    - Informational
    - All
  -Log String[]: ~
  -QueryFile String[]: ~
  -QueryFileId Int32[]: ~
  -StartTime UInt64[]: ~
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
