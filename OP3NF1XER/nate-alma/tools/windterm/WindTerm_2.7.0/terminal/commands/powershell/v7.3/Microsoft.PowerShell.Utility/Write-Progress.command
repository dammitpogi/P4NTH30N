description: Displays a progress bar within a PowerShell command window
synopses:
- Write-Progress [-Activity] <String> [[-Status] <String>] [[-Id] <Int32>] [-PercentComplete
  <Int32>] [-SecondsRemaining <Int32>] [-CurrentOperation <String>] [-ParentId <Int32>]
  [-Completed] [-SourceId <Int32>] [<CommonParameters>]
options:
  -Activity System.String:
    required: true
  -Completed Switch: ~
  -CurrentOperation System.String: ~
  -Id System.Int32: ~
  -ParentId System.Int32: ~
  -PercentComplete System.Int32: ~
  -SecondsRemaining System.Int32: ~
  -SourceId System.Int32: ~
  -Status System.String: ~
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
