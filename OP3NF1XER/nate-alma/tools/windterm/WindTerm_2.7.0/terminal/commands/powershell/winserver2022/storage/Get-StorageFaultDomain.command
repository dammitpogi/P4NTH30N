description: Gets a Storage fault domain object
synopses:
- Get-StorageFaultDomain [-Type <StorageFaultDomainType>] [-PhysicalLocation <String>]
  [-CimSession <CimSession>] [<CommonParameters>]
- Get-StorageFaultDomain [-Type <StorageFaultDomainType>] [-PhysicalLocation <String>]
  -StorageFaultDomain <CimInstance> [-CimSession <CimSession>] [<CommonParameters>]
- Get-StorageFaultDomain [-Type <StorageFaultDomainType>] [-PhysicalLocation <String>]
  -StorageSubsystem <CimInstance> [-CimSession <CimSession>] [<CommonParameters>]
options:
  -CimSession CimSession: ~
  -PhysicalLocation String: ~
  -StorageFaultDomain CimInstance:
    required: true
  -StorageSubsystem CimInstance:
    required: true
  -Type StorageFaultDomainType:
    values:
    - PhysicalDisk
    - StorageEnclosure
    - StorageScaleUnit
    - StorageChassis
    - StorageRack
    - StorageSite
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
