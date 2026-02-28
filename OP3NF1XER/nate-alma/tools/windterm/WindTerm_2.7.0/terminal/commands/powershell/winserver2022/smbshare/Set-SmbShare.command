description: Modifies the properties of the SMB share
synopses:
- Set-SmbShare [-Name] <String[]> [[-ScopeName] <String[]>] [-SmbInstance <SmbInstance>]
  [-Description <String>] [-ConcurrentUserLimit <UInt32>] [-CATimeout <UInt32>] [-ContinuouslyAvailable
  <Boolean>] [-FolderEnumerationMode <FolderEnumerationMode>] [-CachingMode <CachingMode>]
  [-SecurityDescriptor <String>] [-EncryptData <Boolean>] [-CompressData <Boolean>]
  [-LeasingMode <LeasingMode>] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-SmbShare -InputObject <CimInstance[]> [-Description <String>] [-ConcurrentUserLimit
  <UInt32>] [-CATimeout <UInt32>] [-ContinuouslyAvailable <Boolean>] [-FolderEnumerationMode
  <FolderEnumerationMode>] [-CachingMode <CachingMode>] [-SecurityDescriptor <String>]
  [-EncryptData <Boolean>] [-CompressData <Boolean>] [-LeasingMode <LeasingMode>]
  [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -Force Switch: ~
  -InputObject CimInstance[]:
    required: true
  -LeasingMode LeasingMode: ~
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -ScopeName String[]: ~
  -SecurityDescriptor String: ~
  -SmbInstance SmbInstance:
    values:
    - Default
    - CSV
    - SBL
    - SR
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
