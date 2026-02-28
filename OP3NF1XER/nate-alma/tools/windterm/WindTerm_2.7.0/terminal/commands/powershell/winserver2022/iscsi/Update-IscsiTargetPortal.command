description: Updates information about the specified iSCSI target portal
synopses:
- Update-IscsiTargetPortal [-TargetPortalAddress] <String[]> [-InitiatorInstanceName
  <String>] [-InitiatorPortalAddress <String>] [-TargetPortalPortNumber <UInt16>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Update-IscsiTargetPortal -InputObject <CimInstance[]> [-InitiatorInstanceName <String>]
  [-InitiatorPortalAddress <String>] [-TargetPortalPortNumber <UInt16>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InitiatorInstanceName String: ~
  -InitiatorPortalAddress String: ~
  -InputObject CimInstance[]:
    required: true
  -PassThru Switch: ~
  -TargetPortalAddress String[]:
    required: true
  -TargetPortalPortNumber UInt16: ~
  -ThrottleLimit Int32: ~
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
