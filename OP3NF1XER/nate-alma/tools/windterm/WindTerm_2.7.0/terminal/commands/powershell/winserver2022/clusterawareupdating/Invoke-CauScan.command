description: Performs a scan of cluster nodes for applicable updates and gets a list
  of the initial set of updates that are applied to each node in a specified cluster
synopses:
- Invoke-CauScan [[-ClusterName] <String>] [[-CauPluginName] <String[]>] [[-Credential]
  <PSCredential>] [-CauPluginArguments <Hashtable[]>] [-RunPluginsSerially] [-StopOnPluginFailure]
  [<CommonParameters>]
options:
  -CauPluginArguments Hashtable[]: ~
  -CauPluginName String[]: ~
  -ClusterName String: ~
  -Credential PSCredential: ~
  -RunPluginsSerially Switch: ~
  -StopOnPluginFailure Switch: ~
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
