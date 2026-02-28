description: Establishes a connection between the local iSCSI initiator and an iSCSI
  target device
synopses:
- Connect-IscsiTarget -NodeAddress <String> [-TargetPortalAddress <String>] [-TargetPortalPortNumber
  <UInt16>] [-InitiatorPortalAddress <String>] [-IsDataDigest <Boolean>] [-IsHeaderDigest
  <Boolean>] [-IsPersistent <Boolean>] [-ReportToPnP <Boolean>] [-AuthenticationType
  <String>] [-IsMultipathEnabled <Boolean>] [-InitiatorInstanceName <String>] [-ChapUsername
  <String>] [-ChapSecret <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Connect-IscsiTarget [-TargetPortalAddress <String>] [-TargetPortalPortNumber <UInt16>]
  [-InitiatorPortalAddress <String>] [-IsDataDigest <Boolean>] [-IsHeaderDigest <Boolean>]
  [-ReportToPnP <Boolean>] [-AuthenticationType <String>] [-IsMultipathEnabled <Boolean>]
  [-InitiatorInstanceName <String>] [-ChapUsername <String>] [-ChapSecret <String>]
  -InputObject <CimInstance[]> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AuthenticationType String: ~
  -ChapSecret String: ~
  -ChapUsername String: ~
  -CimSession,-Session CimSession[]: ~
  -InitiatorInstanceName String: ~
  -InitiatorPortalAddress String: ~
  -InputObject CimInstance[]:
    required: true
  -IsDataDigest Boolean: ~
  -IsHeaderDigest Boolean: ~
  -IsMultipathEnabled Boolean: ~
  -IsPersistent Boolean: ~
  -NodeAddress String:
    required: true
  -ReportToPnP Boolean: ~
  -TargetPortalAddress,-TA String: ~
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
