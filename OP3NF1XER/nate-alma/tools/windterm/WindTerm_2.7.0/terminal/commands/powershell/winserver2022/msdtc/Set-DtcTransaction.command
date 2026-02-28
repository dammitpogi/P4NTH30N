description: Modifies the state of a transaction
synopses:
- Set-DtcTransaction [-DtcName <String>] -TransactionId <Guid> [-Trace] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-DtcTransaction [-DtcName <String>] -TransactionId <Guid> [-Forget] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-DtcTransaction [-DtcName <String>] -TransactionId <Guid> [-Commit] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-DtcTransaction [-DtcName <String>] -TransactionId <Guid> [-Abort] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -Abort Switch:
    required: true
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Commit Switch:
    required: true
  -DtcName String: ~
  -Forget Switch:
    required: true
  -ThrottleLimit Int32: ~
  -Trace Switch:
    required: true
  -TransactionId Guid:
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
