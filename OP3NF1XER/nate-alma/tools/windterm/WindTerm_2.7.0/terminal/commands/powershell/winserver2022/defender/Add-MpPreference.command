description: Modifies settings for Windows Defender
synopses:
- Add-MpPreference [-ExclusionPath <String[]>] [-ExclusionExtension <String[]>] [-ExclusionProcess
  <String[]>] [-ExclusionIpAddress <String[]>] [-ThreatIDDefaultAction_Ids <Int64[]>]
  [-ThreatIDDefaultAction_Actions <ThreatAction[]>] [-AttackSurfaceReductionOnlyExclusions
  <String[]>] [-ControlledFolderAccessAllowedApplications <String[]>] [-ControlledFolderAccessProtectedFolders
  <String[]>] [-AttackSurfaceReductionRules_Ids <String[]>] [-AttackSurfaceReductionRules_Actions
  <ASRRuleActionType[]>] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AttackSurfaceReductionOnlyExclusions String[]: ~
  -AttackSurfaceReductionRules_Actions ASRRuleActionType[]: ~
  -AttackSurfaceReductionRules_Ids String[]: ~
  -CimSession,-Session CimSession[]: ~
  -ControlledFolderAccessAllowedApplications String[]: ~
  -ControlledFolderAccessProtectedFolders String[]: ~
  -ExclusionExtension String[]: ~
  -ExclusionIpAddress String[]: ~
  -ExclusionPath String[]: ~
  -ExclusionProcess String[]: ~
  -Force Switch: ~
  -ThreatIDDefaultAction_Actions,-tiddefaca ThreatAction[]:
    values:
    - Clean
    - Quarantine
    - Remove
    - Allow
    - UserDefined
    - NoAction
    - Block
  -ThreatIDDefaultAction_Ids,-tiddefaci Int64[]: ~
  -ThrottleLimit Int32: ~
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
