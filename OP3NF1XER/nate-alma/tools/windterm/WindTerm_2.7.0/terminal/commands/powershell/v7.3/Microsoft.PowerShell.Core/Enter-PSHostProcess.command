description: Connects to and enters into an interactive session with a local process
synopses:
- Enter-PSHostProcess [-Id] <Int32> [[-AppDomainName] <String>] [<CommonParameters>]
- Enter-PSHostProcess [-Process] <Process> [[-AppDomainName] <String>] [<CommonParameters>]
- Enter-PSHostProcess [-Name] <String> [[-AppDomainName] <String>] [<CommonParameters>]
- Enter-PSHostProcess [-HostProcessInfo] <PSHostProcessInfo> [[-AppDomainName] <String>]
  [<CommonParameters>]
- Enter-PSHostProcess -CustomPipeName <String> [<CommonParameters>]
options:
  -AppDomainName System.String: ~
  -CustomPipeName System.String:
    required: true
  -HostProcessInfo Microsoft.PowerShell.Commands.PSHostProcessInfo:
    required: true
  -Id System.Int32:
    required: true
  -Name System.String:
    required: true
  -Process System.Diagnostics.Process:
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
