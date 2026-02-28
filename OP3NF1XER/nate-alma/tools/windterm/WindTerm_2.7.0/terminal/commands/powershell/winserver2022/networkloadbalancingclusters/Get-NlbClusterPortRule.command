description: Gets the port rule objects that are queried by the caller
synopses:
- Get-NlbClusterPortRule [-HostName <String>] [-InterfaceName <String>] [-IP <IPAddress>]
  [[-Port] <UInt32>] [-NodeName <String>] [<CommonParameters>]
- Get-NlbClusterPortRule -InputObject <PSObject[]> [-IP <IPAddress>] [[-Port] <UInt32>]
  [<CommonParameters>]
options:
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress: ~
  -InputObject PSObject[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String: ~
  -NodeName,-NN String: ~
  -Port UInt32: ~
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
