description: Sets the maximum number of idle virtual desktops on host servers
synopses:
- Set-RDVirtualDesktopIdleCount [-IdleCount] <Int32> [[-HostServer] <String[]>] [-ConnectionBroker
  <String>] [-BatchSize <Int32>] [<CommonParameters>]
- Set-RDVirtualDesktopIdleCount [-Allocation] <Hashtable> [-ConnectionBroker <String>]
  [-BatchSize <Int32>] [<CommonParameters>]
options:
  -Allocation Hashtable:
    required: true
  -BatchSize Int32: ~
  -ConnectionBroker String: ~
  -HostServer String[]: ~
  -IdleCount Int32:
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
