description: Gets persistent memory disks
synopses:
- Get-PmemDisk [<CommonParameters>]
- Get-PmemDisk [[-DiskNumber] <UInt32[]>] [<CommonParameters>]
- Get-PmemDisk [-PhysicalDevice <PmemPhysicalDevice>] [<CommonParameters>]
- Get-PmemDisk [-PhysicalDeviceId <String[]>] [<CommonParameters>]
- Get-PmemDisk [-InputObject <CimInstance>] [<CommonParameters>]
options:
  -DiskNumber UInt32[]: ~
  -InputObject CimInstance: ~
  -PhysicalDevice PmemPhysicalDevice: ~
  -PhysicalDeviceId String[]: ~
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
