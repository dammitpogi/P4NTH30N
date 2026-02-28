description: Generates an IPv6 address to use with the NLB cmdlets
synopses:
- New-NlbClusterIpv6Address [[-HostName] <String>] [-InterfaceName] <String> [-LinkLocal]
  [-Global] [<CommonParameters>]
options:
  -Global,-G Switch: ~
  -HostName,-Host,-HN,-H String: ~
  -InterfaceName,-Interface,-IN,-I String:
    required: true
  -LinkLocal,-L Switch: ~
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
