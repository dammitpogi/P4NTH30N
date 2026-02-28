description: Configures an application controlled by a script that runs in Windows
  Script Host, within a failover cluster
synopses:
- Add-ClusterGenericScriptRole -ScriptFilePath <String> [-Storage <StringCollection>]
  [-StaticAddress <StringCollection>] [-IgnoreNetwork <StringCollection>] [[-Name]
  <String>] [-Wait <Int32>] [-InputObject <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -IgnoreNetwork StringCollection: ~
  -InputObject PSObject: ~
  -Name String: ~
  -ScriptFilePath String:
    required: true
  -StaticAddress StringCollection: ~
  -Storage StringCollection: ~
  -Wait Int32: ~
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
