description: Sets or changes the file system label of an existing volume
synopses:
- Set-Volume [-NewFileSystemLabel <String>] -DriveLetter <Char> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Volume -InputObject <CimInstance[]> [-DedupMode <DedupMode>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Volume -InputObject <CimInstance[]> [-NewFileSystemLabel <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Volume [-NewFileSystemLabel <String>] -FileSystemLabel <String> [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Volume [-NewFileSystemLabel <String>] -Path <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Volume [-NewFileSystemLabel <String>] -UniqueId <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Volume -UniqueId <String> [-DedupMode <DedupMode>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Volume -Path <String> [-DedupMode <DedupMode>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Volume -FileSystemLabel <String> [-DedupMode <DedupMode>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-Volume -DriveLetter <Char> [-DedupMode <DedupMode>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DedupMode DedupMode:
    values:
    - Disabled
    - GeneralPurpose
    - HyperV
    - Backup
    - NotAvailable
  -DriveLetter Char:
    required: true
  -FileSystemLabel String:
    required: true
  -InputObject CimInstance[]:
    required: true
  -NewFileSystemLabel String: ~
  -Path String:
    required: true
  -ThrottleLimit Int32: ~
  -UniqueId String:
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
