description: Gets diagnostics for a cluster a cluster that contains VMs and produces
  a zip file containing the data
synopses:
- Get-ClusterDiagnosticInfo [[-WriteToPath] <String>] [[-Cluster] <String>] [[-ZipPrefix]
  <String>] [-HoursOfEvents <Int32>] [-IncludeEvents] [<CommonParameters>]
- Get-ClusterDiagnosticInfo -ReadFromPath <String> [<CommonParameters>]
options:
  -Cluster String: ~
  -HoursOfEvents Int32: ~
  -IncludeEvents Switch: ~
  -ReadFromPath String:
    required: true
  -WriteToPath String: ~
  -ZipPrefix String: ~
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
