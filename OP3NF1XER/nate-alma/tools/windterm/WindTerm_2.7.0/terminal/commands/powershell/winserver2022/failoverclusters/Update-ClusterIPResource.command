description: Renews or releases the DHCP lease for an IP address resource in a failover
  cluster
synopses:
- Update-ClusterIPResource [[-Name] <String>] [-Renew] [-Release] [-InputObject <PSObject>]
  [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -InputObject PSObject: ~
  -Name String: ~
  -Release Switch: ~
  -Renew Switch: ~
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
