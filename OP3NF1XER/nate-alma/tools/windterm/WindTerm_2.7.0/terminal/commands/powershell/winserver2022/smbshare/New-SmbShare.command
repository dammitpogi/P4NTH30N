description: Creates an SMB share
synopses:
- New-SmbShare [-Temporary] [-ContinuouslyAvailable <Boolean>] [-Description <String>]
  [-ConcurrentUserLimit <UInt32>] [-CATimeout <UInt32>] [-FolderEnumerationMode <FolderEnumerationMode>]
  [-CachingMode <CachingMode>] [-FullAccess <String[]>] [-ChangeAccess <String[]>]
  [-ReadAccess <String[]>] [-NoAccess <String[]>] [-SecurityDescriptor <String>] [-Path]
  <String> [-Name] <String> [[-ScopeName] <String>] [-EncryptData <Boolean>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CATimeout UInt32: ~
  -CachingMode CachingMode:
    values:
    - None
    - Manual
    - Documents
    - Programs
    - BranchCache
    - Unknown
  -ChangeAccess String[]: ~
  -CimSession,-Session CimSession[]: ~
  -CompressData Boolean: ~
  -ConcurrentUserLimit UInt32: ~
  -ContinuouslyAvailable Boolean: ~
  -Description String: ~
  -EncryptData Boolean: ~
  -FolderEnumerationMode FolderEnumerationMode:
    values:
    - AccessBased
    - Unrestricted
  -FullAccess String[]: ~
  -LeasingMode LeasingMode: ~
  -Name String:
    required: true
  -NoAccess String[]: ~
  -Path String:
    required: true
  -ReadAccess String[]: ~
  -ScopeName String: ~
  -SecurityDescriptor String: ~
  -Temporary Switch: ~
  -ThrottleLimit Int32: ~
  -Confirm,-cf Switch: ~
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
