description: Gets the Updating Run reports for all known Updating Runs, or all Updating
  Runs that match the specified dates or other specified parameters
synopses:
- Get-CauReport [[-ClusterName] <String>] [-Detailed] [-Credential <PSCredential>]
  [<CommonParameters>]
- Get-CauReport [[-ClusterName] <String>] [[-StartDate] <DateTime>] [[-EndDate] <DateTime>]
  [-Detailed] [-Credential <PSCredential>] [<CommonParameters>]
- Get-CauReport [[-ClusterName] <String>] [-Last] [-Detailed] [-Credential <PSCredential>]
  [<CommonParameters>]
- Get-CauReport [[-ClusterName] <String>] [-Report <CauReportSummary>] [-Credential
  <PSCredential>] [<CommonParameters>]
options:
  -ClusterName String: ~
  -Credential PSCredential: ~
  -Detailed Switch: ~
  -EndDate DateTime: ~
  -Last Switch: ~
  -Report CauReportSummary: ~
  -StartDate DateTime: ~
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
