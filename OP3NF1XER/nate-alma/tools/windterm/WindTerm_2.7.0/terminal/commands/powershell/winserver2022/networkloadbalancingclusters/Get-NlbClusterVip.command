description: Gets virtual IP addresses that are queried by the caller
synopses:
- Get-NlbClusterVip [-HostName <String>] [-InterfaceName <String>] [[-IP] <IPAddress>]
  [<CommonParameters>]
- Get-NlbClusterVip -InputObject <Cluster[]> [[-IP] <IPAddress>] [<CommonParameters>]
options:
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress: ~
  -InputObject Cluster[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String: ~
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
