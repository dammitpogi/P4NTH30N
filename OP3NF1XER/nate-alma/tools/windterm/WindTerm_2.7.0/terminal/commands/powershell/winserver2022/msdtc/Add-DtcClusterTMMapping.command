description: Adds a cluster DTC mapping
synopses:
- Add-DtcClusterTMMapping -Name <String> -ClusterResourceName <String> -Local <Boolean>
  [-PassThru] -Service <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
- Add-DtcClusterTMMapping -Name <String> -ClusterResourceName <String> -Local <Boolean>
  [-PassThru] -ExecutablePath <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
- Add-DtcClusterTMMapping -Name <String> -ClusterResourceName <String> -ComPlusAppId
  <String> -Local <Boolean> [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClusterResourceName String:
    required: true
  -ComPlusAppId String:
    required: true
  -ExecutablePath String:
    required: true
  -Local Boolean:
    required: true
  -Name String:
    required: true
  -PassThru Switch: ~
  -Service String:
    required: true
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
