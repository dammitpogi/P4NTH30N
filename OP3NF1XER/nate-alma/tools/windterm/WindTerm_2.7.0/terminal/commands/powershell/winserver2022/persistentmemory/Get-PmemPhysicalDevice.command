description: Gets the physical devices associated with persistent memory
synopses:
- Get-PmemPhysicalDevice [<CommonParameters>]
- Get-PmemPhysicalDevice [[-DeviceId] <String[]>] [<CommonParameters>]
- Get-PmemPhysicalDevice [-LogicalDisk <PmemDisk>] [<CommonParameters>]
- Get-PmemPhysicalDevice [-DiskNumber <UInt32>] [<CommonParameters>]
- Get-PmemPhysicalDevice [-InputObject <CimInstance>] [<CommonParameters>]
options:
  -DeviceId String[]: ~
  -DiskNumber UInt32: ~
  -InputObject CimInstance: ~
  -LogicalDisk PmemDisk: ~
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
