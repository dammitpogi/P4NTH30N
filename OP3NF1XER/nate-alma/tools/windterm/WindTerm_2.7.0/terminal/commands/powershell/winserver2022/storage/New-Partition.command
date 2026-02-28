description: Creates a new partition on an existing Disk object
synopses:
- New-Partition [-DiskNumber] <UInt32[]> [-Size <UInt64>] [-UseMaximumSize] [-Offset
  <UInt64>] [-Alignment <UInt32>] [-DriveLetter <Char>] [-AssignDriveLetter] [-MbrType
  <MbrType>] [-GptType <String>] [-IsHidden] [-IsActive] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- New-Partition -DiskId <String[]> [-Size <UInt64>] [-UseMaximumSize] [-Offset <UInt64>]
  [-Alignment <UInt32>] [-DriveLetter <Char>] [-AssignDriveLetter] [-MbrType <MbrType>]
  [-GptType <String>] [-IsHidden] [-IsActive] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- New-Partition -DiskPath <String[]> [-Size <UInt64>] [-UseMaximumSize] [-Offset <UInt64>]
  [-Alignment <UInt32>] [-DriveLetter <Char>] [-AssignDriveLetter] [-MbrType <MbrType>]
  [-GptType <String>] [-IsHidden] [-IsActive] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- New-Partition -InputObject <CimInstance[]> [-Size <UInt64>] [-UseMaximumSize] [-Offset
  <UInt64>] [-Alignment <UInt32>] [-DriveLetter <Char>] [-AssignDriveLetter] [-MbrType
  <MbrType>] [-GptType <String>] [-IsHidden] [-IsActive] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -Alignment UInt32: ~
  -AsJob Switch: ~
  -AssignDriveLetter Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DiskId,-Id String[]:
    required: true
  -DiskNumber UInt32[]:
    required: true
  -DiskPath String[]:
    required: true
  -DriveLetter,-NewDriveLetter Char: ~
  -GptType String: ~
  -InputObject CimInstance[]:
    required: true
  -IsActive Switch: ~
  -IsHidden Switch: ~
  -MbrType MbrType:
    values:
    - FAT12
    - FAT16
    - Extended
    - Huge
    - IFS
    - FAT32
  -Offset UInt64: ~
  -Size UInt64: ~
  -ThrottleLimit Int32: ~
  -UseMaximumSize Switch: ~
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
