description: Lists devices available to the system that can be managed by the MSDSM
  for MPIO
synopses:
- Get-MPIOAvailableHW [[-VendorId] <String[]>] [[-ProductId] <String[]>] [-BusType
  <BusType[]>] [-IsMultipathed <Boolean[]>] [-IsSPC3Supported <Boolean[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BusType BusType[]:
    values:
    - FibreChannel
    - iSCSI
    - SAS
  -CimSession,-Session CimSession[]: ~
  -IsMultipathed Boolean[]: ~
  -IsSPC3Supported Boolean[]: ~
  -ProductId String[]: ~
  -ThrottleLimit Int32: ~
  -VendorId String[]: ~
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
