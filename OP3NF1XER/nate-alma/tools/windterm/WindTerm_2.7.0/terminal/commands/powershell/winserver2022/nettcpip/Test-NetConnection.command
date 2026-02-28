description: Displays diagnostic information for a connection
synopses:
- Test-NetConnection [[-ComputerName] <String>] [-TraceRoute] [-Hops <Int32>] [-InformationLevel
  <String>] [<CommonParameters>]
- Test-NetConnection [[-ComputerName] <String>] [-CommonTCPPort] <String> [-InformationLevel
  <String>] [<CommonParameters>]
- Test-NetConnection [[-ComputerName] <String>] -Port <Int32> [-InformationLevel <String>]
  [<CommonParameters>]
- Test-NetConnection [[-ComputerName] <String>] [-DiagnoseRouting] [-ConstrainSourceAddress
  <String>] [-ConstrainInterface <UInt32>] [-InformationLevel <String>] [<CommonParameters>]
options:
  -CommonTCPPort String:
    required: true
    values:
    - HTTP
    - RDP
    - SMB
    - WINRM
  -ComputerName,-RemoteAddress,-cn String: ~
  -ConstrainInterface UInt32: ~
  -ConstrainSourceAddress String: ~
  -DiagnoseRouting Switch:
    required: true
  -Hops Int32: ~
  -InformationLevel String:
    values:
    - Quiet
    - Detailed
  -Port,-RemotePort Int32:
    required: true
  -TraceRoute Switch: ~
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
