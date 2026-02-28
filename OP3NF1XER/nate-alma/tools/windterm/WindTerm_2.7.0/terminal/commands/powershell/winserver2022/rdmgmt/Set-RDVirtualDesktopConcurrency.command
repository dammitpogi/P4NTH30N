description: Sets the number of virtual desktops that RDS can create in parallel
synopses:
- Set-RDVirtualDesktopConcurrency [-ConcurrencyFactor] <Int32> [[-HostServer] <String[]>]
  [-ConnectionBroker <String>] [-BatchSize <Int32>] [<CommonParameters>]
- Set-RDVirtualDesktopConcurrency [-Allocation] <Hashtable> [-ConnectionBroker <String>]
  [-BatchSize <Int32>] [<CommonParameters>]
options:
  -Allocation Hashtable:
    required: true
  -BatchSize Int32: ~
  -ConcurrencyFactor Int32:
    required: true
  -ConnectionBroker String: ~
  -HostServer String[]: ~
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
