description: Compares two sets of objects
synopses:
- Compare-Object [-ReferenceObject] <PSObject[]> [-DifferenceObject] <PSObject[]>
  [-SyncWindow <Int32>] [-Property <Object[]>] [-ExcludeDifferent] [-IncludeEqual]
  [-PassThru] [-Culture <String>] [-CaseSensitive] [<CommonParameters>]
options:
  -CaseSensitive Switch: ~
  -Culture System.String: ~
  -DifferenceObject System.Management.Automation.PSObject[]:
    required: true
  -ExcludeDifferent Switch: ~
  -IncludeEqual Switch: ~
  -PassThru Switch: ~
  -Property System.Object[]: ~
  -ReferenceObject System.Management.Automation.PSObject[]:
    required: true
  -SyncWindow System.Int32: ~
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
