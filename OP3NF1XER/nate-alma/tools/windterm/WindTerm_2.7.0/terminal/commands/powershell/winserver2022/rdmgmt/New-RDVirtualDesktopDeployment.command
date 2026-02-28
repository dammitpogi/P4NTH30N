description: Installs role services for Virtual Desktop Infrastructure
synopses:
- New-RDVirtualDesktopDeployment [-ConnectionBroker] <String> [-VirtualizationHost]
  <String[]> [[-WebAccessServer] <String>] [-CreateVirtualSwitch] [<CommonParameters>]
options:
  -ConnectionBroker String:
    required: true
  -CreateVirtualSwitch Switch: ~
  -VirtualizationHost String[]:
    required: true
  -WebAccessServer String: ~
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
