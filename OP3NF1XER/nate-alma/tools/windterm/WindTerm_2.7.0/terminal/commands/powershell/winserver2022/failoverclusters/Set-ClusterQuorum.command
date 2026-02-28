description: Configures quorum options for a failover cluster
synopses:
- Set-ClusterQuorum [-DiskOnly <String>] [-NoWitness] [-DiskWitness <String>] [-FileShareWitness
  <String>] [-CloudWitness] [-AccountName <String>] [-Endpoint <String>] [-AccessKey
  <String>] [-InputObject <PSObject>] [-Cluster <String>] [<CommonParameters>]
options:
  -AccessKey String: ~
  -AccountName String: ~
  -CloudWitness Switch: ~
  -Cluster String: ~
  -DiskOnly String: ~
  -DiskWitness,-NodeAndDiskMajority String: ~
  -Endpoint String: ~
  -FileShareWitness,-NodeAndFileShareMajority String: ~
  -InputObject PSObject: ~
  -NoWitness,-NodeMajority Switch: ~
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
