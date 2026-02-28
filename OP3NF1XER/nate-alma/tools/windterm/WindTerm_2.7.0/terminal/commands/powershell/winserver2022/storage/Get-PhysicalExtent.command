description: This cmdlet gets physical allocations for a physical disk, storage tier,
  or virtual disk. The "extent" (also known as "allocation" or "slab")  is the area
  on a pooled disk containing one fragment of data for storage space
synopses:
- yaml Get-PhysicalExtent -VirtualDisk <CimInstance> [-CimSession <CimSession>] [<CommonParameters>]
- yaml Get-PhysicalExtent -StorageTier <CimInstance> [-CimSession <CimSession>] [<CommonParameters>]
- yaml Get-PhysicalExtent -PhysicalDisk <CimInstance> [-CimSession <CimSession>] [<CommonParameters>]
options:
  -CimSession CimSession: ~
  -PhysicalDisk CimInstance:
    required: true
  -StorageTier CimInstance:
    required: true
  -VirtualDisk CimInstance:
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
