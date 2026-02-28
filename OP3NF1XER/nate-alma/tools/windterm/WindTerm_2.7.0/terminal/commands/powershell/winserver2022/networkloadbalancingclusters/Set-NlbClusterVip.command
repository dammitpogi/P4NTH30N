description: Edits the virtual IP address of a NLB cluster
synopses:
- Set-NlbClusterVip [-HostName <String>] -InterfaceName <String> [-IP] <IPAddress>
  -NewIP <IPAddress> [<CommonParameters>]
- Set-NlbClusterVip -InputObject <ClusterVip[]> -NewIP <IPAddress> [<CommonParameters>]
options:
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress:
    required: true
  -InputObject ClusterVip[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String:
    required: true
  -NewIP IPAddress:
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
