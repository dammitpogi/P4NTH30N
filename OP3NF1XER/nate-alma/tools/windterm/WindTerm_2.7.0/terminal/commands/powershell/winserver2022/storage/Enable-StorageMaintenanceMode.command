description: Enables storage maintenance mode on a device
synopses:
- Enable-StorageMaintenanceMode -InputObject <CimInstance> [-IgnoreDetachedVirtualDisks]
  [-ValidateVirtualDisksHealthy <Boolean>] [-Model <String>] [-Manufacturer <String>]
  [-CimSession <CimSession>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession CimSession: ~
  -IgnoreDetachedVirtualDisks Switch: ~
  -InputObject CimInstance:
    required: true
  -Manufacturer String: ~
  -Model String: ~
  -ValidateVirtualDisksHealthy Boolean: ~
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
