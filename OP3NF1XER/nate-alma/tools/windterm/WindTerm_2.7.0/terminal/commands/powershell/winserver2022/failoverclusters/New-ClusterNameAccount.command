description: Creates a cluster name account in Active Directory Domain Services
synopses:
- New-ClusterNameAccount -Name <String> [-Credentials <PSCredential>] [-Domain <String>]
  [-InputObject <PSObject>] [-Cluster <String>] [<CommonParameters>]
- New-ClusterNameAccount -Name <String> -Credentials <PSCredential> -Domain <String>
  [-Cluster <String>] [<CommonParameters>]
options:
  -Cluster String: ~
  -Credentials PSCredential: ~
  -Domain String: ~
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
