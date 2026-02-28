description: Collects logs from an SLB MUX and DIP host
synopses:
- Debug-SlbDatapath [[-OperationId] <String>] [-SourceIP] <String> [-TargetVIP] <String>
  [-PortNumber] <UInt16> [-Muxes] <Hashtable[]> [-Dips] <Hashtable[]> [[-TraceFolderPath]
  <String>] [<CommonParameters>]
options:
  -Dips Hashtable[]:
    required: true
  -Muxes Hashtable[]:
    required: true
  -OperationId String: ~
  -PortNumber UInt16:
    required: true
  -SourceIP String:
    required: true
  -TargetVIP String:
    required: true
  -TraceFolderPath String: ~
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
