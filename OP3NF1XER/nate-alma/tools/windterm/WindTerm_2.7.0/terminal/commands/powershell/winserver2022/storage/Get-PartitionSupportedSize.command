description: Returns information on supported partition sizes for the specified Disk
  object
synopses:
- Get-PartitionSupportedSize [<CommonParameters>]
- Get-PartitionSupportedSize -DiskId <String[]> [-Offset <UInt64[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-PartitionSupportedSize [-DiskNumber] <UInt32[]> [[-PartitionNumber] <UInt32[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-PartitionSupportedSize -DriveLetter <Char[]> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-PartitionSupportedSize -InputObject <CimInstance[]> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DiskId String[]:
    required: true
  -DiskNumber UInt32[]:
    required: true
  -DriveLetter Char[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -Offset UInt64[]: ~
  -PartitionNumber,-Number UInt32[]: ~
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
