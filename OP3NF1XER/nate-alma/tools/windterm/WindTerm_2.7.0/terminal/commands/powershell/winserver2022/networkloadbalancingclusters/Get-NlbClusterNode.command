description: Gets information about a node object or the NLB cluster object that is
  queried by the caller
synopses:
- Get-NlbClusterNode [-HostName <String>] [-InterfaceName <String>] [[-NodeName] <String>]
  [<CommonParameters>]
- Get-NlbClusterNode -InputObject <Cluster[]> [-HostName <String>] [[-NodeName] <String>]
  [<CommonParameters>]
options:
  -HostName,-Host,-HN,-H String: ~
  -InputObject Cluster[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String: ~
  -NodeName,-Name,-NN String: ~
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
