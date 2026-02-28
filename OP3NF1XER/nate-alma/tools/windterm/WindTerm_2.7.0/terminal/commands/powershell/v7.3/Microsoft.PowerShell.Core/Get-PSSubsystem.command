description: Retrieves information about the subsystems registered in PowerShell
synopses:
- Get-PSSubsystem [<CommonParameters>]
- Get-PSSubsystem -Kind <SubsystemKind> [<CommonParameters>]
- Get-PSSubsystem -SubsystemType <Type> [<CommonParameters>]
options:
  -Kind System.Management.Automation.Subsystem.SubsystemKind:
    required: true
    values:
    - CommandPredictor
  -SubsystemType System.Type:
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
