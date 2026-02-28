description: Tests whether DIPs are reachable
synopses:
- Test-VipReachability [[-OperationId] <String>] [-SourceIP] <String> [[-CompartmentId]
  <String>] [-TargetVIP] <String> [-Muxes] <Hashtable[]> [-Dips] <Hashtable[]> [[-SequenceNumber]
  <Int32>] [[-PayloadSize] <Int32>] [<CommonParameters>]
options:
  -CompartmentId String: ~
  -Dips Hashtable[]:
    required: true
  -Muxes Hashtable[]:
    required: true
  -OperationId String: ~
  -PayloadSize Int32: ~
  -SequenceNumber Int32: ~
  -SourceIP String:
    required: true
  -TargetVIP String:
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
