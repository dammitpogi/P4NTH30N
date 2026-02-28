description: Modifies an existing cluster DTC mapping
synopses:
- Set-DtcClusterTMMapping -Name <String> [-ClusterResourceName <String>] [-Local <Boolean>]
  -Service <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Set-DtcClusterTMMapping -Name <String> -ClusterResourceName <String> [-Local <Boolean>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-DtcClusterTMMapping -Name <String> [-ClusterResourceName <String>] -Local <Boolean>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-DtcClusterTMMapping -Name <String> [-ClusterResourceName <String>] [-Local <Boolean>]
  -ExecutablePath <String> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
- Set-DtcClusterTMMapping -Name <String> -ComPlusAppId <String> [-ClusterResourceName
  <String>] [-Local <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClusterResourceName String: ~
  -ComPlusAppId String:
    required: true
  -ExecutablePath String:
    required: true
  -Local Boolean: ~
  -Name String:
    required: true
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
