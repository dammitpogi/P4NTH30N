description: Removes a virtual IP address from a NLB cluster
synopses:
- Remove-NlbClusterVip [-PassThru] [-Force] [-HostName <String>] [-InterfaceName <String>]
  [-IP] <IPAddress> [<CommonParameters>]
- Remove-NlbClusterVip -InputObject <ClusterVip[]> [-PassThru] [-Force] [<CommonParameters>]
options:
  -Force,-F Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress:
    required: true
  -InputObject ClusterVip[]:
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
