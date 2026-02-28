description: Gets iSCSI target portals
synopses:
- Get-IscsiTargetPortal [-InitiatorPortalAddress <String[]>] [[-TargetPortalAddress]
  <String[]>] [-InitiatorInstanceName <String[]>] [-TargetPortalPortNumber <UInt16[]>]
  [-IsHeaderDigest <Boolean[]>] [-IsDataDigest <Boolean[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiTargetPortal [-iSCSISession <CimInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiTargetPortal [-iSCSIConnection <CimInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiTargetPortal [-iSCSITarget <CimInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InitiatorInstanceName String[]: ~
  -InitiatorPortalAddress String[]: ~
  -IsDataDigest Boolean[]: ~
  -IsHeaderDigest Boolean[]: ~
  -TargetPortalAddress String[]: ~
  -TargetPortalPortNumber UInt16[]: ~
  -ThrottleLimit Int32: ~
  -iSCSIConnection CimInstance: ~
  -iSCSISession CimInstance: ~
  -iSCSITarget CimInstance: ~
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
