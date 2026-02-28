description: Finds problems with a volume and recommends solutions
synopses:
- Debug-Volume [-DriveLetter] <Char[]> [-CimSession <CimSession>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Debug-Volume -ObjectId <String[]> [-CimSession <CimSession>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Debug-Volume -Path <String[]> [-CimSession <CimSession>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Debug-Volume -FileSystemLabel <String[]> [-CimSession <CimSession>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Debug-Volume -InputObject <CimInstance> [-CimSession <CimSession>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession: ~
  -DriveLetter Char[]:
    required: true
  -FileSystemLabel String[]:
    required: true
  -InputObject CimInstance:
    required: true
  -ObjectId String[]:
    required: true
  -Path String[]:
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
