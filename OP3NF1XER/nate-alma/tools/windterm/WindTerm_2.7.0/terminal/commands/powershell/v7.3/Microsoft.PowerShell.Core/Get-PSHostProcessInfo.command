description: Gets process information about the PowerShell host
synopses:
- Get-PSHostProcessInfo [[-Name] <String[]>] [<CommonParameters>]
- Get-PSHostProcessInfo [-Process] <Process[]> [<CommonParameters>]
- Get-PSHostProcessInfo [-Id] <Int32[]> [<CommonParameters>]
options:
  -Id System.Int32[]:
    required: true
  -Name System.String[]: ~
  -Process System.Diagnostics.Process[]:
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
