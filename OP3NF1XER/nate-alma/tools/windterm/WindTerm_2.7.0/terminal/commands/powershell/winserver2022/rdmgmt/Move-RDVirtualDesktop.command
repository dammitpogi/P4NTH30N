description: Moves a virtual desktop to a new Remote Desktop Virtualization Host (RD
  Virtualization Host) server
synopses:
- Move-RDVirtualDesktop [-SourceHost] <String> [-DestinationHost] <String> [-Name]
  <String> [[-ConnectionBroker] <String>] [[-Credential] <PSCredential>] [<CommonParameters>]
options:
  -ConnectionBroker String: ~
  -Credential PSCredential: ~
  -DestinationHost String:
    required: true
  -Name String:
    required: true
  -SourceHost String:
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
