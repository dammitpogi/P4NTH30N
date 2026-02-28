description: Creates a persistent memory disk in an unused persistent memory region
synopses:
- New-PmemDisk -RegionId <UInt32[]> [-FriendlyName <String[]>] [-DiskSizeInBytes <UInt64[]>]
  [-AtomicityType <NAMESPACE_ATOMICITY_TYPE[]>] [<CommonParameters>]
- New-PmemDisk -DiskSizeInBytes <UInt64[]> [-AtomicityType <NAMESPACE_ATOMICITY_TYPE[]>]
  [-Simulated] [<CommonParameters>]
options:
  -AtomicityType NAMESPACE_ATOMICITY_TYPE[]:
    values:
    - None
    - BlockTranslationTable
  -DiskSizeInBytes UInt64[]: ~
  -FriendlyName String[]: ~
  -RegionId UInt32[]:
    required: true
  -Simulated Switch:
    required: true
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
