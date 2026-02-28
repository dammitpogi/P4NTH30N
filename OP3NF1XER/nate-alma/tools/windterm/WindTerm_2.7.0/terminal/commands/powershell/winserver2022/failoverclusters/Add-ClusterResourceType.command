description: Adds a resource type to a failover cluster, and specifies information
  such as the dynamic-link library (DLL) to use with that resource type
synopses:
- Add-ClusterResourceType [-Name] <String> [-Dll] <String> [[-DisplayName] <String>]
  [-InputObject <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -DisplayName String: ~
  -Dll String:
    required: true
  -InputObject PSObject: ~
  -Name String:
    required: true
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
