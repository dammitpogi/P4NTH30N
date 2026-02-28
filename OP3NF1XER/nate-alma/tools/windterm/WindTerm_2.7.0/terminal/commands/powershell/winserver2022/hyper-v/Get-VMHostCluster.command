description: Gets virtual machine host clusters
synopses:
- Get-VMHostCluster [-ClusterName] <String[]> [[-Credential] <PSCredential[]>] [<CommonParameters>]
- Get-VMHostCluster [-CimSession] <CimSession[]> [<CommonParameters>]
options:
  -CimSession CimSession[]:
    required: true
  -ClusterName String[]:
    required: true
  -Credential PSCredential[]: ~
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
