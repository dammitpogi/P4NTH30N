description: Gets the CIM session objects from the current session
synopses:
- Get-CimSession [[-ComputerName] <String[]>] [<CommonParameters>]
- Get-CimSession [-Id] <UInt32[]> [<CommonParameters>]
- Get-CimSession -InstanceId <Guid[]> [<CommonParameters>]
- Get-CimSession -Name <String[]> [<CommonParameters>]
options:
  -ComputerName,-CN,-ServerName System.String[]: ~
  -Id System.UInt32[]:
    required: true
  -InstanceId System.Guid[]:
    required: true
  -Name System.String[]:
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
