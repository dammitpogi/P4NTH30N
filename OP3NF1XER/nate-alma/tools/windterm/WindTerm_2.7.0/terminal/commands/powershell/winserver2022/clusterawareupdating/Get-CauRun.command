description: Gets status information about an updating run currently in progress
synopses:
- Get-CauRun [[-ClusterName] <String>] [-Credential <PSCredential>] [<CommonParameters>]
- Get-CauRun [[-ClusterName] <String>] [-Credential <PSCredential>] [-WaitForStart]
  [<CommonParameters>]
- Get-CauRun [[-ClusterName] <String>] [-Credential <PSCredential>] [-WaitForCompletion]
  [<CommonParameters>]
- Get-CauRun [[-ClusterName] <String>] [-Credential <PSCredential>] [-ShowClusterNodeState]
  [<CommonParameters>]
options:
  -ClusterName String: ~
  -Credential PSCredential: ~
  -ShowClusterNodeState Switch: ~
  -WaitForCompletion Switch: ~
  -WaitForStart Switch: ~
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
