description: Creates an access point for a remote file share
synopses:
- New-FileShare -FileServerFriendlyName <String[]> -Name <String> [-Description <String>]
  -SourceVolume <CimInstance> [-RelativePathName <String>] [-ContinuouslyAvailable
  <Boolean>] [-EncryptData <Boolean>] [-Protocol <FileSharingProtocol>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-FileShare -FileServerUniqueId <String[]> -Name <String> [-Description <String>]
  -SourceVolume <CimInstance> [-RelativePathName <String>] [-ContinuouslyAvailable
  <Boolean>] [-EncryptData <Boolean>] [-Protocol <FileSharingProtocol>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-FileShare -InputObject <CimInstance[]> -Name <String> [-Description <String>]
  -SourceVolume <CimInstance> [-RelativePathName <String>] [-ContinuouslyAvailable
  <Boolean>] [-EncryptData <Boolean>] [-Protocol <FileSharingProtocol>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -ContinuouslyAvailable Boolean: ~
  -Description String: ~
  -EncryptData Boolean: ~
  -FileServerFriendlyName String[]:
    required: true
  -FileServerUniqueId,-Id String[]:
    required: true
  -InputObject CimInstance[]:
    required: true
  -Name String:
    required: true
  -Protocol FileSharingProtocol:
    values:
    - NFS
    - SMB
  -RelativePathName String: ~
  -SourceVolume CimInstance:
    required: true
  -ThrottleLimit Int32: ~
  -WhatIf,-wi Switch: ~
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
