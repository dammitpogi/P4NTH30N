description: Removes a port rule from a NLB cluster
synopses:
- Remove-NlbClusterPortRule [-PassThru] [-HostName <String>] -InterfaceName <String>
  -IP <IPAddress> [[-Port] <UInt32>] [-Force] [<CommonParameters>]
- Remove-NlbClusterPortRule -InputObject <PortRule[]> [-PassThru] [-Force] [<CommonParameters>]
options:
  -Force,-F Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress:
    required: true
  -InputObject PortRule[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String:
    required: true
  -PassThru,-Pass Switch: ~
  -Port,-P UInt32: ~
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
