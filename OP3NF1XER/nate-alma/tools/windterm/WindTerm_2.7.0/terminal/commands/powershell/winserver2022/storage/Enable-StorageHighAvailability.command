description: Enables a disk to be added to the failover cluster
synopses:
- Enable-StorageHighAvailability [-DiskNumber] <UInt32[]> [-ScaleOut <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Enable-StorageHighAvailability -DiskUniqueId <String[]> [-ScaleOut <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Enable-StorageHighAvailability -DiskFriendlyName <String[]> [-ScaleOut <Boolean>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Enable-StorageHighAvailability -DiskPath <String[]> [-ScaleOut <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Enable-StorageHighAvailability -InputObject <CimInstance[]> [-ScaleOut <Boolean>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DiskFriendlyName String[]:
    required: true
  -DiskNumber UInt32[]:
    required: true
  -DiskPath String[]:
    required: true
  -DiskUniqueId,-DiskId String[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -ScaleOut Boolean: ~
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
