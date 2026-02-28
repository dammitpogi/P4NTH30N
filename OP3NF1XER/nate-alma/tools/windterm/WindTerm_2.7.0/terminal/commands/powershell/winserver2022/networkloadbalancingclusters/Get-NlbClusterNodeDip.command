description: Gets the dedicated IP address that is queried by the caller
synopses:
- Get-NlbClusterNodeDip [-HostName <String>] [-InterfaceName <String>] [-NodeName
  <String>] [[-IP] <IPAddress>] [<CommonParameters>]
- Get-NlbClusterNodeDip -InputObject <Node[]> [[-IP] <IPAddress>] [<CommonParameters>]
options:
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress: ~
  -InputObject Node[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String: ~
  -NodeName,-NN String: ~
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
