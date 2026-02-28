description: Modifies the settings for a Sync Share
synopses:
- Set-SyncShare [-Name] <String[]> [-Description <String>] [-User <String[]>] [-InheritParentFolderPermission]
  [-MaxUploadFile <UInt64>] [-RequireEncryption <Boolean>] [-RequirePasswordAutoLock
  <Boolean>] [-FallbackEnterpriseID <String>] [-PasswordAutolockExcludeDomain <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-SyncShare -InputObject <CimInstance[]> [-Description <String>] [-User <String[]>]
  [-InheritParentFolderPermission] [-MaxUploadFile <UInt64>] [-RequireEncryption <Boolean>]
  [-RequirePasswordAutoLock <Boolean>] [-FallbackEnterpriseID <String>] [-PasswordAutolockExcludeDomain
  <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -FallbackEnterpriseID String: ~
  -InheritParentFolderPermission Switch: ~
  -InputObject CimInstance[]:
    required: true
  -MaxUploadFile UInt64: ~
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -PasswordAutolockExcludeDomain String[]: ~
  -RequireEncryption Boolean: ~
  -RequirePasswordAutoLock Boolean: ~
  -ThrottleLimit Int32: ~
  -User,-AllowedAccount,-AllowedUser String[]: ~
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
