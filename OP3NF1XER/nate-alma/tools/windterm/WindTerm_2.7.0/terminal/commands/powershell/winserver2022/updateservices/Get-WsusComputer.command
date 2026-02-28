description: Gets the WSUS computer object that represents the client computer
synopses:
- powershell Get-WsusComputer [-UpdateServer <IUpdateServer>] [-All] [<CommonParameters>]
- powershell Get-WsusComputer [-UpdateServer <IUpdateServer>] [-NameIncludes <String>]
  [-ComputerTargetGroups <StringCollection>] [-IncludeSubgroups] [-ComputerUpdateStatus
  <WsusUpdateInstallationState>] [-ExcludedInstallationStates <UpdateInstallationStates[]>]
  [-IncludedInstallationStates <UpdateInstallationStates[]>] [-FromLastSyncTime <DateTime>]
  [-ToLastSyncTime <DateTime>] [-FromLastReportedStatusTime <DateTime>] [-ToLastReportedStatusTime
  <DateTime>] [-IncludeDownstreamComputerTargets] [-RequestedTargetGroupNames <StringCollection>]
  [<CommonParameters>]
options:
  -All Switch: ~
  -ComputerTargetGroups StringCollection: ~
  -ComputerUpdateStatus WsusUpdateInstallationState:
    values:
    - NoStatus
    - InstalledOrNotApplicable
    - InstalledOrNotApplicableOrNoStatus
    - Failed
    - Needed
    - FailedOrNeeded
    - Any
  -ExcludedInstallationStates UpdateInstallationStates[]:
    values:
    - Unknown
    - NotApplicable
    - NotInstalled
    - Downloaded
    - Installed
    - Failed
    - InstalledPendingReboot
    - All
  -FromLastReportedStatusTime DateTime: ~
  -FromLastSyncTime DateTime: ~
  -IncludeDownstreamComputerTargets Switch: ~
  -IncludeSubgroups Switch: ~
  -IncludedInstallationStates UpdateInstallationStates[]:
    values:
    - Unknown
    - NotApplicable
    - NotInstalled
    - Downloaded
    - Installed
    - Failed
    - InstalledPendingReboot
    - All
  -NameIncludes String: ~
  -RequestedTargetGroupNames StringCollection: ~
  -ToLastReportedStatusTime DateTime: ~
  -ToLastSyncTime DateTime: ~
  -UpdateServer IUpdateServer: ~
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
