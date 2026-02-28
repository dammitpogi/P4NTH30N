description: Removes a dedicate IP address from a NLB cluster
synopses:
- Remove-NlbClusterNodeDip [-PassThru] [-Force] [-HostName <String>] [-InterfaceName
  <String>] [-IP] <IPAddress> [<CommonParameters>]
- Remove-NlbClusterNodeDip -InputObject <ClusterNodeDip[]> [-PassThru] [-Force] [<CommonParameters>]
options:
  -Force,-F Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress:
    required: true
  -InputObject ClusterNodeDip[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String: ~
  -PassThru,-Pass Switch: ~
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
