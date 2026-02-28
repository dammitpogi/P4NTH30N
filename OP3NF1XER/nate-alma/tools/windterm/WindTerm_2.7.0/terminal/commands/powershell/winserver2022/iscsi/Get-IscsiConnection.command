description: Gets information about connected iSCSI initiator connections
synopses:
- Get-IscsiConnection [-ConnectionIdentifier <String[]>] [-InitiatorPortalPortNumber
  <UInt16[]>] [-InititorIPAdressListNumber <UInt16[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiConnection [-InitiatorSideIdentifier <String[]>] [-InitiatorPortalPortNumber
  <UInt16[]>] [-InititorIPAdressListNumber <UInt16[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiConnection [-TargetSideIdentifier <String[]>] [-InitiatorPortalPortNumber
  <UInt16[]>] [-InititorIPAdressListNumber <UInt16[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiConnection [-InitiatorPortalAddress <String[]>] [-InitiatorPortalPortNumber
  <UInt16[]>] [-InititorIPAdressListNumber <UInt16[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiConnection [-InitiatorPortalPortNumber <UInt16[]>] [-InititorIPAdressListNumber
  <UInt16[]>] [-IscsiTarget <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiConnection [-InitiatorPortalPortNumber <UInt16[]>] [-InititorIPAdressListNumber
  <UInt16[]>] [-InitiatorPort <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiConnection [-InitiatorPortalPortNumber <UInt16[]>] [-InititorIPAdressListNumber
  <UInt16[]>] [-IscsiSession <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiConnection [-InitiatorPortalPortNumber <UInt16[]>] [-InititorIPAdressListNumber
  <UInt16[]>] [-iSCSITargetPortal <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Get-IscsiConnection [-InitiatorPortalPortNumber <UInt16[]>] [-InititorIPAdressListNumber
  <UInt16[]>] [-Disk <CimInstance>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ConnectionIdentifier String[]: ~
  -Disk CimInstance: ~
  -InitiatorPort CimInstance: ~
  -InitiatorPortalAddress String[]: ~
  -InitiatorPortalPortNumber UInt16[]: ~
  -InitiatorSideIdentifier String[]: ~
  -InititorIPAdressListNumber UInt16[]: ~
  -IscsiSession CimInstance: ~
  -IscsiTarget CimInstance: ~
  -TargetSideIdentifier String[]: ~
  -ThrottleLimit Int32: ~
  -iSCSITargetPortal CimInstance: ~
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
