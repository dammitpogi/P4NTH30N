description: Gets the WSUS update object with details about the update
synopses:
- powershell Get-WsusUpdate [-UpdateServer <IUpdateServer>] -UpdateId <Guid> [-RevisionNumber
  <Int32>] [<CommonParameters>]
- powershell Get-WsusUpdate [-UpdateServer <IUpdateServer>] [-Classification <WsusUpdateClassifications>]
  [-Approval <WsusApprovedState>] [-Status <WsusUpdateInstallationState>] [<CommonParameters>]
options:
  -Approval WsusApprovedState:
    values:
    - Approved
    - Unapproved
    - AnyExceptDeclined
    - Declined
  -Classification WsusUpdateClassifications:
    values:
    - All
    - Critical
    - Security
    - WSUS
  -RevisionNumber Int32: ~
  -Status WsusUpdateInstallationState:
    values:
    - NoStatus
    - InstalledOrNotApplicable
    - InstalledOrNotApplicableOrNoStatus
    - Failed
    - Needed
    - FailedOrNeeded
    - Any
  -UpdateId Guid:
    required: true
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
