description: Adds a virtual disk to a specified masking set and grants access to the
  virtual disk to all initiator IDs defined in the masking set
synopses:
- Add-VirtualDiskToMaskingSet [-MaskingSetFriendlyName] <String[]> [-VirtualDisknames
  <String[]>] [-DeviceNumbers <UInt16[]>] [-DeviceAccesses <DeviceAccess[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-VirtualDiskToMaskingSet -MaskingSetUniqueId <String[]> [-VirtualDisknames <String[]>]
  [-DeviceNumbers <UInt16[]>] [-DeviceAccesses <DeviceAccess[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VirtualDiskToMaskingSet -InputObject <CimInstance[]> [-VirtualDisknames <String[]>]
  [-DeviceNumbers <UInt16[]>] [-DeviceAccesses <DeviceAccess[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DeviceAccesses DeviceAccess[]:
    values:
    - Unknown
    - ReadWrite
    - ReadOnly
    - NoAccess
  -DeviceNumbers UInt16[]: ~
  -InputObject CimInstance[]:
    required: true
  -MaskingSetFriendlyName String[]:
    required: true
  -MaskingSetUniqueId,-Id String[]:
    required: true
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -VirtualDisknames String[]: ~
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
