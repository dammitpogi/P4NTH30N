description: Tests whether a jumbo packet can be sent between two nodes
synopses:
- Test-LogicalNetworkSupportsJumboPacket [-SourceHost] <String> [-DestinationHost]
  <String> [[-SourceHostCreds] <PSCredential>] [[-DestinationHostCreds] <PSCredential>]
  [<CommonParameters>]
options:
  -DestinationHost String:
    required: true
  -DestinationHostCreds PSCredential: ~
  -SourceHost String:
    required: true
  -SourceHostCreds PSCredential: ~
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
