description: Creates a clustered file server resource group
synopses:
- Add-ClusterFileServerRole -Storage <StringCollection> [-StaticAddress <StringCollection>]
  [-IgnoreNetwork <StringCollection>] [[-Name] <String>] [-Wait <Int32>] [-InputObject
  <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -IgnoreNetwork StringCollection: ~
  -InputObject PSObject: ~
  -Name String: ~
  -StaticAddress StringCollection: ~
  -Storage StringCollection:
    required: true
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
