description: Creates a new failover cluster
synopses:
- New-Cluster [-Name] <String> [-Node <StringCollection>] [-StaticAddress <StringCollection>]
  [-IgnoreNetwork <StringCollection>] [-NoStorage] [-S2D] [-AdministrativeAccessPoint
  <AdminAccessPoint>] [-Force] [<CommonParameters>]
options:
  -AdministrativeAccessPoint,-aap AdminAccessPoint:
    values:
    - None
    - ActiveDirectoryAndDns
    - Dns
    - ActiveDirectory
  -Force Switch: ~
  -IgnoreNetwork StringCollection: ~
  -Name String:
    required: true
  -NoStorage Switch: ~
  -Node StringCollection: ~
  -S2D Switch: ~
  -StaticAddress StringCollection: ~
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
