description: Associates a virtual desktop collection with a new virtual desktop template
synopses:
- Update-RDVirtualDesktopCollection [-CollectionName] <String> -VirtualDesktopTemplateName
  <String> -VirtualDesktopTemplateHostServer <String> [-DisableVirtualDesktopRollback]
  [-VirtualDesktopPasswordAge <Int32>] [-ConnectionBroker <String>] [-Force] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Update-RDVirtualDesktopCollection [-CollectionName] <String> -VirtualDesktopTemplateName
  <String> -VirtualDesktopTemplateHostServer <String> [-DisableVirtualDesktopRollback]
  [-VirtualDesktopPasswordAge <Int32>] [-ConnectionBroker <String>] [-Force] -StartTime
  <DateTime> -ForceLogoffTime <DateTime> [-WhatIf] [-Confirm] [<CommonParameters>]
- Update-RDVirtualDesktopCollection [-CollectionName] <String> -VirtualDesktopTemplateName
  <String> -VirtualDesktopTemplateHostServer <String> [-DisableVirtualDesktopRollback]
  [-VirtualDesktopPasswordAge <Int32>] [-ConnectionBroker <String>] [-Force] -ForceLogoffTime
  <DateTime> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CollectionName String:
    required: true
  -Confirm,-cf Switch: ~
  -ConnectionBroker String: ~
  -DisableVirtualDesktopRollback Switch: ~
  -Force Switch: ~
  -ForceLogoffTime DateTime:
    required: true
  -StartTime DateTime:
    required: true
  -VirtualDesktopPasswordAge Int32: ~
  -VirtualDesktopTemplateHostServer String:
    required: true
  -VirtualDesktopTemplateName String:
    required: true
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
