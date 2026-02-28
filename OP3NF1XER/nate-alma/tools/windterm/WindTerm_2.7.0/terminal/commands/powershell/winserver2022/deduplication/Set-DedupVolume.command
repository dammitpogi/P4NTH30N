description: Changes data deduplication settings on one or more volumes
synopses:
- powershell Set-DedupVolume [-VolumeId <String[]>] [-OptimizeInUseFiles] [-OptimizePartialFiles]
  [-NoCompress <Boolean>] [-Verify <Boolean>] [-MinimumFileAgeDays <UInt32>] [-MinimumFileSize
  <UInt32>] [-ChunkRedundancyThreshold <UInt32>] [-ExcludeFolder <String[]>] [-ExcludeFileType
  <String[]>] [-ExcludeFileTypeDefault <String[]>] [-NoCompressionFileType <String[]>]
  [-InputOutputScale <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [<CommonParameters>]
- powershell Set-DedupVolume [-Volume] <String[]> [-OptimizeInUseFiles] [-OptimizePartialFiles]
  [-NoCompress <Boolean>] [-Verify <Boolean>] [-MinimumFileAgeDays <UInt32>] [-MinimumFileSize
  <UInt32>] [-ChunkRedundancyThreshold <UInt32>] [-ExcludeFolder <String[]>] [-ExcludeFileType
  <String[]>] [-ExcludeFileTypeDefault <String[]>] [-NoCompressionFileType <String[]>]
  [-InputOutputScale <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [<CommonParameters>]
- powershell Set-DedupVolume -InputObject <CimInstance[]> [-OptimizeInUseFiles] [-OptimizePartialFiles]
  [-NoCompress <Boolean>] [-Verify <Boolean>] [-MinimumFileAgeDays <UInt32>] [-MinimumFileSize
  <UInt32>] [-ChunkRedundancyThreshold <UInt32>] [-ExcludeFolder <String[]>] [-ExcludeFileType
  <String[]>] [-ExcludeFileTypeDefault <String[]>] [-NoCompressionFileType <String[]>]
  [-InputOutputScale <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -ChunkRedundancyThreshold UInt32: ~
  -CimSession,-Session CimSession[]: ~
  -ExcludeFileType String[]: ~
  -ExcludeFileTypeDefault String[]: ~
  -ExcludeFolder String[]: ~
  -InputObject CimInstance[]:
    required: true
  -InputOutputScale UInt32: ~
  -MinimumFileAgeDays,-MinimumFileAge UInt32: ~
  -MinimumFileSize UInt32: ~
  -NoCompress Boolean: ~
  -NoCompressionFileType String[]: ~
  -OptimizeInUseFiles Switch: ~
  -OptimizePartialFiles Switch: ~
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -Verify Boolean: ~
  -Volume String[]:
    required: true
  -VolumeId,-DeviceId,-Path,-Id String[]: ~
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
