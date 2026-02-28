description: Turns on maintenance for a disk resource or CSV so that you can run a
  disk maintenance tool without triggering failover
synopses:
- Suspend-ClusterResource [[-Name] <String>] [-VolumeName <String>] [-RedirectedAccess]
  [-Force] [-InputObject <PSObject>] [-Cluster <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Cluster String: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -InputObject PSObject: ~
  -Name String: ~
  -RedirectedAccess,-FileSystemRedirectedAccess Switch: ~
  -VolumeName String: ~
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
