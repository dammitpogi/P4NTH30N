description: Enables scheduled updates while disk protection is enabled and in discard
  mode
synopses:
- Enable-WmsScheduledUpdate [-AutomaticUpdateMode <EAutomaticUpdateMode>] [-HourToScheduleUpdates
  <UInt32>] [-CustomScript <String>] [-MaxTimeAllowedForCustomScript <UInt32>] [-ReturnState
  <EScheduleUpdateReturnState>] [-Server <String>] [<CommonParameters>]
options:
  -AutomaticUpdateMode EAutomaticUpdateMode:
    values:
    - None
    - WindowsOnly
    - WindowsAndOtherPrograms
  -CustomScript String: ~
  -HourToScheduleUpdates UInt32: ~
  -MaxTimeAllowedForCustomScript UInt32: ~
  -ReturnState EScheduleUpdateReturnState:
    values:
    - Shutdown
    - PreviousState
  -Server,-ComputerName String: ~
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
