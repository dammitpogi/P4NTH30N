description: Grants access to a failover cluster, either full access or read-only
  access
synopses:
- Grant-ClusterAccess [-User] <StringCollection> [-Full] [-ReadOnly] [-InputObject
  <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -Full Switch: ~
  -InputObject PSObject: ~
  -ReadOnly Switch: ~
  -User StringCollection:
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
