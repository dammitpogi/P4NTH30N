description: Adds virtual desktops to a virtual desktop collection
synopses:
- Add-RDVirtualDesktopToCollection [-CollectionName] <String> -VirtualDesktopAllocation
  <Hashtable> [-VirtualDesktopPasswordAge <Int32>] [-ConnectionBroker <String>] [<CommonParameters>]
- Add-RDVirtualDesktopToCollection [-CollectionName] <String> -VirtualDesktopName
  <String[]> [-ConnectionBroker <String>] [<CommonParameters>]
- Add-RDVirtualDesktopToCollection [-CollectionName] <String> -VirtualDesktopAllocation
  <Hashtable> [-VirtualDesktopTemplateName <String>] [-VirtualDesktopTemplateHostServer
  <String>] [-ConnectionBroker <String>] [<CommonParameters>]
options:
  -CollectionName String:
    required: true
  -ConnectionBroker String: ~
  -VirtualDesktopAllocation Hashtable:
    required: true
  -VirtualDesktopName String[]:
    required: true
  -VirtualDesktopPasswordAge Int32: ~
  -VirtualDesktopTemplateHostServer String: ~
  -VirtualDesktopTemplateName String: ~
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
