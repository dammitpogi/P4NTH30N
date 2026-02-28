description: Configures an iSCSI target portal
synopses:
- New-IscsiTargetPortal -TargetPortalAddress <String> [-TargetPortalPortNumber <UInt16>]
  [-InitiatorPortalAddress <String>] [-IsHeaderDigest <Boolean>] [-IsDataDigest <Boolean>]
  [-AuthenticationType <String>] [-InitiatorInstanceName <String>] [-ChapUsername
  <String>] [-ChapSecret <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AuthenticationType String: ~
  -ChapSecret String: ~
  -ChapUsername String: ~
  -CimSession,-Session CimSession[]: ~
  -InitiatorInstanceName String: ~
  -InitiatorPortalAddress,-IA String: ~
  -IsDataDigest Boolean: ~
  -IsHeaderDigest Boolean: ~
  -TargetPortalAddress,-TA String:
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
