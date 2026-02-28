description: Removes the specified iSCSI target portal
synopses:
- Remove-IscsiTargetPortal -TargetPortalAddress <String[]> [-InitiatorInstanceName
  <String>] [-InitiatorPortalAddress <String>] [-TargetPortalPortNumber <Int32>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-IscsiTargetPortal -InputObject <CimInstance[]> [-InitiatorInstanceName <String>]
  [-InitiatorPortalAddress <String>] [-TargetPortalPortNumber <Int32>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -InitiatorInstanceName String: ~
  -InitiatorPortalAddress String: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -TargetPortalAddress String[]:
    required: true
  -TargetPortalPortNumber Int32: ~
  -ThrottleLimit Int32: ~
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
