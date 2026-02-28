description: Edits the dedicated IP address of a NLB cluster
synopses:
- Set-NlbClusterNodeDip [-HostName <String>] -InterfaceName <String> [-IP] <IPAddress>
  -NewDip <IPAddress> [<CommonParameters>]
- Set-NlbClusterNodeDip -InputObject <ClusterNodeDip[]> -NewDip <IPAddress> [<CommonParameters>]
options:
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress:
    required: true
  -InputObject ClusterNodeDip[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String:
    required: true
  -NewDip IPAddress:
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
