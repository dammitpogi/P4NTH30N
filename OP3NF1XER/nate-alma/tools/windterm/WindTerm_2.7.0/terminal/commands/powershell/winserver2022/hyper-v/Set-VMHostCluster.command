description: Configures a virtual machine host cluster
synopses:
- Set-VMHostCluster [-ClusterName] <String[]> [[-Credential] <PSCredential[]>] [-SharedStoragePath
  <String>] [-Passthru] [<CommonParameters>]
- Set-VMHostCluster [-CimSession] <CimSession[]> [-SharedStoragePath <String>] [-Passthru]
  [<CommonParameters>]
- Set-VMHostCluster [-InputObject] <VMHostCluster[]> [-SharedStoragePath <String>]
  [-Passthru] [<CommonParameters>]
options:
  -CimSession CimSession[]:
    required: true
  -ClusterName String[]:
    required: true
  -Credential PSCredential[]: ~
  -InputObject VMHostCluster[]:
    required: true
  -Passthru Switch: ~
  -SharedStoragePath String: ~
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
