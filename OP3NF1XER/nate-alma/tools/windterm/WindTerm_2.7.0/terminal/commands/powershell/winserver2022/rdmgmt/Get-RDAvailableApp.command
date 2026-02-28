description: Gets a list of publishable applications from a collection
synopses:
- Get-RDAvailableApp [-CollectionName] <String> [-ConnectionBroker <String>] [<CommonParameters>]
- Get-RDAvailableApp [-CollectionName] <String> -VirtualDesktopName <String> [-ConnectionBroker
  <String>] [<CommonParameters>]
options:
  -CollectionName String:
    required: true
  -ConnectionBroker String: ~
  -VirtualDesktopName,-VMName String:
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
