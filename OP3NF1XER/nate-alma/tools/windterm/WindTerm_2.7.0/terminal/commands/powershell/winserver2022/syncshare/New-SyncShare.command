description: Creates a Sync Share
synopses:
- New-SyncShare [-Name] <String> [-Description <String>] [-Type <String>] [-Path]
  <String> [-UserFolderName <String>] [-User] <String[]> [-InheritParentFolderPermission]
  [-MaxUploadFile <UInt64>] [-RequireEncryption <Boolean>] [-RequirePasswordAutoLock
  <Boolean>] [-FallbackEnterpriseID <String>] [-PasswordAutolockExcludeDomain <String[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -FallbackEnterpriseID String: ~
  -InheritParentFolderPermission Switch: ~
  -MaxUploadFile UInt64: ~
  -Name String:
    required: true
  -PasswordAutolockExcludeDomain String[]: ~
  -Path String:
    required: true
  -RequireEncryption Boolean: ~
  -RequirePasswordAutoLock Boolean: ~
  -ThrottleLimit Int32: ~
  -Type String: ~
  -User,-AllowedAccount,-AllowedUser String[]:
    required: true
  -UserFolderName String: ~
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
