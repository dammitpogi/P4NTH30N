description: Configures preferences for Windows Defender scans and updates
synopses:
- Set-MpPreference [-ExclusionPath <String[]>] [-ExclusionExtension <String[]>] [-ExclusionProcess
  <String[]>] [-ExclusionIpAddress <String[]>] [-RealTimeScanDirection <ScanDirection>]
  [-QuarantinePurgeItemsAfterDelay <UInt32>] [-RemediationScheduleDay <Day>] [-RemediationScheduleTime
  <DateTime>] [-ReportingAdditionalActionTimeOut <UInt32>] [-ReportingCriticalFailureTimeOut
  <UInt32>] [-ReportingNonCriticalTimeOut <UInt32>] [-ScanAvgCPULoadFactor <Byte>]
  [-CheckForSignaturesBeforeRunningScan <Boolean>] [-ScanPurgeItemsAfterDelay <UInt32>]
  [-ScanOnlyIfIdleEnabled <Boolean>] [-ScanParameters <ScanType>] [-ScanScheduleDay
  <Day>] [-ScanScheduleQuickScanTime <DateTime>] [-ScanScheduleTime <DateTime>] [-SignatureFirstAuGracePeriod
  <UInt32>] [-SignatureAuGracePeriod <UInt32>] [-SignatureDefinitionUpdateFileSharesSources
  <String>] [-SignatureDisableUpdateOnStartupWithoutEngine <Boolean>] [-SignatureFallbackOrder
  <String>] [-SharedSignaturesPath <String>] [-SignatureScheduleDay <Day>] [-SignatureScheduleTime
  <DateTime>] [-SignatureUpdateCatchupInterval <UInt32>] [-SignatureUpdateInterval
  <UInt32>] [-SignatureBlobUpdateInterval <UInt32>] [-SignatureBlobFileSharesSources
  <String>] [-MeteredConnectionUpdates <Boolean>] [-AllowNetworkProtectionOnWinServer
  <Boolean>] [-DisableDatagramProcessing <Boolean>] [-DisableCpuThrottleOnIdleScans
  <Boolean>] [-MAPSReporting <MAPSReportingType>] [-SubmitSamplesConsent <SubmitSamplesConsentType>]
  [-DisableAutoExclusions <Boolean>] [-DisablePrivacyMode <Boolean>] [-RandomizeScheduleTaskTimes
  <Boolean>] [-SchedulerRandomizationTime <UInt32>] [-DisableBehaviorMonitoring <Boolean>]
  [-DisableRealtimeMonitoring <Boolean>] [-DisableScriptScanning <Boolean>] [-DisableArchiveScanning
  <Boolean>] [-DisableCatchupFullScan <Boolean>] [-DisableCatchupQuickScan <Boolean>]
  [-DisableEmailScanning <Boolean>] [-DisableRemovableDriveScanning <Boolean>] [-DisableRestorePoint
  <Boolean>] [-DisableScanningMappedNetworkDrivesForFullScan <Boolean>] [-DisableScanningNetworkFiles
  <Boolean>] [-UILockdown <Boolean>] [-ThreatIDDefaultAction_Ids <Int64[]>] [-ThreatIDDefaultAction_Actions
  <ThreatAction[]>] [-UnknownThreatDefaultAction <ThreatAction>] [-LowThreatDefaultAction
  <ThreatAction>] [-ModerateThreatDefaultAction <ThreatAction>] [-HighThreatDefaultAction
  <ThreatAction>] [-SevereThreatDefaultAction <ThreatAction>] [-Force] [-DisableBlockAtFirstSeen
  <Boolean>] [-PUAProtection <PUAProtectionType>] [-CloudBlockLevel <CloudBlockLevelType>]
  [-CloudExtendedTimeout <UInt32>] [-EnableNetworkProtection <ASRRuleActionType>]
  [-EnableControlledFolderAccess <ControlledFolderAccessType>] [-AttackSurfaceReductionOnlyExclusions
  <String[]>] [-ControlledFolderAccessAllowedApplications <String[]>] [-ControlledFolderAccessProtectedFolders
  <String[]>] [-AttackSurfaceReductionRules_Ids <String[]>] [-AttackSurfaceReductionRules_Actions
  <ASRRuleActionType[]>] [-EnableLowCpuPriority <Boolean>] [-EnableFileHashComputation
  <Boolean>] [-EnableFullScanOnBatteryPower <Boolean>] [-ProxyPacUrl <String>] [-ProxyServer
  <String>] [-ProxyBypass <String[]>] [-ForceUseProxyOnly <Boolean>] [-DisableTlsParsing
  <Boolean>] [-DisableHttpParsing <Boolean>] [-DisableDnsParsing <Boolean>] [-DisableDnsOverTcpParsing
  <Boolean>] [-DisableSshParsing <Boolean>] [-PlatformUpdatesChannel <UpdatesChannelType>]
  [-EngineUpdatesChannel <UpdatesChannelType>] [-SignaturesUpdatesChannel <UpdatesChannelType>]
  [-DisableGradualRelease <Boolean>] [-AllowNetworkProtectionDownLevel <Boolean>]
  [-AllowDatagramProcessingOnWinServer <Boolean>] [-EnableDnsSinkhole <Boolean>] [-DisableInboundConnectionFiltering
  <Boolean>] [-DisableRdpParsing <Boolean>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AllowDatagramProcessingOnWinServer,-adpows Boolean: ~
  -AllowNetworkProtectionDownLevel,-anpdl Boolean: ~
  -AllowNetworkProtectionOnWinServer,-anpws Boolean: ~
  -AsJob Switch: ~
  -AttackSurfaceReductionOnlyExclusions String[]: ~
  -AttackSurfaceReductionRules_Actions ASRRuleActionType[]: ~
  -AttackSurfaceReductionRules_Ids String[]: ~
  -CheckForSignaturesBeforeRunningScan,-csbr Boolean: ~
  -CimSession,-Session CimSession[]: ~
  -CloudBlockLevel CloudBlockLevelType: ~
  -CloudExtendedTimeout,-cloudextimeout UInt32: ~
  -ControlledFolderAccessAllowedApplications String[]: ~
  -ControlledFolderAccessProtectedFolders String[]: ~
  -DisableArchiveScanning,-darchsc Boolean: ~
  -DisableAutoExclusions,-dae Boolean: ~
  -DisableBehaviorMonitoring,-dbm Boolean: ~
  -DisableBlockAtFirstSeen,-dbaf Boolean: ~
  -DisableCatchupFullScan,-dcfsc Boolean: ~
  -DisableCatchupQuickScan,-dcqsc Boolean: ~
  -DisableCpuThrottleOnIdleScans,-None Boolean: ~
  -DisableDatagramProcessing,-ddtgp Boolean: ~
  -DisableDnsOverTcpParsing,-ddnstcpp Boolean: ~
  -DisableDnsParsing,-ddnsp Boolean: ~
  -DisableEmailScanning,-demsc Boolean: ~
  -DisableGradualRelease,-dgr Boolean: ~
  -DisableHttpParsing,-dhttpp Boolean: ~
  -DisableInboundConnectionFiltering,-dicf Boolean: ~
  -DisableIOAVProtection,-dioavp Boolean: ~
  -DisablePrivacyMode,-dpm Boolean: ~
  -DisableRdpParsing,-drdpp Boolean: ~
  -DisableRealtimeMonitoring,-drtm Boolean: ~
  -DisableRemovableDriveScanning,-drdsc Boolean: ~
  -DisableRestorePoint,-drp,-dsnf Boolean: ~
  -DisableScanningMappedNetworkDrivesForFullScan,-dsmndfsc Boolean: ~
  -DisableScanningNetworkFiles,-dsnf Boolean: ~
  -DisableScriptScanning,-dscrptsc Boolean: ~
  -DisableSshParsing,-dsshp Boolean: ~
  -DisableTlsParsing,-dtlsp Boolean: ~
  -EnableControlledFolderAccess ControlledFolderAccessType: ~
  -EnableDnsSinkhole,-ednss Boolean: ~
  -EnableFileHashComputation,-efhc Boolean: ~
  -EnableFullScanOnBatteryPower,-efsobp Boolean: ~
  -EnableLowCpuPriority,-elcp Boolean: ~
  -EnableNetworkProtection ASRRuleActionType: ~
  -EngineUpdatesChannel,-erelr UpdatesChannelType: ~
  -ExclusionExtension String[]: ~
  -ExclusionIpAddress String[]: ~
  -ExclusionPath String[]: ~
  -ExclusionProcess String[]: ~
  -Force Switch: ~
  -ForceUseProxyOnly,-fupo Boolean: ~
  -HighThreatDefaultAction,-htdefac ThreatAction:
    values:
    - Clean
    - Quarantine
    - Remove
    - Allow
    - UserDefined
    - NoAction
    - Block
  -LowThreatDefaultAction,-ltdefac ThreatAction:
    values:
    - Clean
    - Quarantine
    - Remove
    - Allow
    - UserDefined
    - NoAction
    - Block
  -MAPSReporting MAPSReportingType:
    values:
    - Disabled
    - Basic
    - Advanced
  -MeteredConnectionUpdates,-mcupd Boolean: ~
  -ModerateThreatDefaultAction,-mtdefac ThreatAction:
    values:
    - Clean
    - Quarantine
    - Remove
    - Allow
    - UserDefined
    - NoAction
    - Block
  -PlatformUpdatesChannel,-prelr UpdatesChannelType: ~
  -ProxyBypass,-proxbps String[]: ~
  -ProxyPacUrl,-ppurl String: ~
  -ProxyServer,-proxsrv String: ~
  -PUAProtection PUAProtectionType:
    values:
    - Disabled
    - Enabled
    - AuditMode
  -QuarantinePurgeItemsAfterDelay,-qpiad UInt32: ~
  -RandomizeScheduleTaskTimes,-rstt Boolean: ~
  -RealTimeScanDirection,-rtsd ScanDirection:
    values:
    - Both
    - Incoming
    - Outcoming
  -RemediationScheduleDay,-rsd Day:
    values:
    - Everyday
    - Sunday
    - Monday
    - Tuesday
    - Wednesday
    - Thursday
    - Friday
    - Saturday
    - Never
  -RemediationScheduleTime,-rst DateTime: ~
  -ReportingAdditionalActionTimeOut,-raat UInt32: ~
  -ReportingCriticalFailureTimeOut,-rcto UInt32: ~
  -ReportingNonCriticalTimeOut,-rncto UInt32: ~
  -ScanAvgCPULoadFactor,-saclf Byte: ~
  -ScanOnlyIfIdleEnabled,-soiie Boolean: ~
  -ScanParameters ScanType:
    values:
    - QuickScan
    - FullScan
  -ScanPurgeItemsAfterDelay,-spiad UInt32: ~
  -ScanScheduleDay,-scsd Day:
    values:
    - Everyday
    - Sunday
    - Monday
    - Tuesday
    - Wednesday
    - Thursday
    - Friday
    - Saturday
    - Never
  -ScanScheduleQuickScanTime,-scsqst DateTime: ~
  -ScanScheduleTime,-scst DateTime: ~
  -SchedulerRandomizationTime,-srt UInt32: ~
  -SevereThreatDefaultAction,-stdefac ThreatAction:
    values:
    - Clean
    - Quarantine
    - Remove
    - Allow
    - UserDefined
    - NoAction
    - Block
  -SharedSignaturesPath,-ssp,-SecurityIntelligenceLocation,-ssl String: ~
  -SignatureAuGracePeriod,-sigagp UInt32: ~
  -SignatureBlobFileSharesSources,-sigbfs String: ~
  -SignatureBlobUpdateInterval,-sigbui UInt32: ~
  -SignatureDefinitionUpdateFileSharesSources,-sigdufss String: ~
  -SignatureDisableUpdateOnStartupWithoutEngine,-sigduoswo Boolean: ~
  -SignatureFallbackOrder,-sfo String: ~
  -SignatureFirstAuGracePeriod,-sigfagp UInt32: ~
  -SignatureScheduleDay,-sigsd Day:
    values:
    - Everyday
    - Sunday
    - Monday
    - Tuesday
    - Wednesday
    - Thursday
    - Friday
    - Saturday
    - Never
  -SignatureScheduleTime,-sigst DateTime: ~
  -SignaturesUpdatesChannel,-srelr UpdatesChannelType: ~
  -SignatureUpdateCatchupInterval,-siguci UInt32: ~
  -SignatureUpdateInterval,-sigui UInt32: ~
  -SubmitSamplesConsent SubmitSamplesConsentType:
    values:
    - AlwaysPrompt
    - SendSafeSamples
    - NeverSend
    - SendAllSamples
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
  -UILockdown Boolean: ~
  -UnknownThreatDefaultAction,-unktdefac ThreatAction:
    values:
    - Clean
    - Quarantine
    - Remove
    - Allow
    - UserDefined
    - NoAction
    - Block
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
