description: Gets configuration details of a virtual desktop collection
synopses:
- Get-RDVirtualDesktopCollectionConfiguration [-CollectionName] <String> [-ConnectionBroker
  <String>] [<CommonParameters>]
- Get-RDVirtualDesktopCollectionConfiguration [-CollectionName] <String> [-VirtualDesktopConfiguration]
  [-ConnectionBroker <String>] [<CommonParameters>]
- Get-RDVirtualDesktopCollectionConfiguration [-CollectionName] <String> [-UserGroups]
  [-ConnectionBroker <String>] [<CommonParameters>]
- Get-RDVirtualDesktopCollectionConfiguration [-CollectionName] <String> [-Client]
  [-ConnectionBroker <String>] [<CommonParameters>]
- Get-RDVirtualDesktopCollectionConfiguration [-CollectionName] <String> [-UserProfileDisks]
  [-ConnectionBroker <String>] [<CommonParameters>]
options:
  -Client Switch:
    required: true
  -CollectionName String:
    required: true
  -ConnectionBroker String: ~
  -UserGroups Switch:
    required: true
  -UserProfileDisks Switch:
    required: true
  -VirtualDesktopConfiguration Switch:
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
