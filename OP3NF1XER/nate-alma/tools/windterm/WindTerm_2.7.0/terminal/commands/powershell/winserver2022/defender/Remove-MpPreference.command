description: Removes exclusions or default actions
synopses:
- Remove-MpPreference [-ExclusionPath <String[]>] [-ExclusionExtension <String[]>]
  [-ExclusionProcess <String[]>] [-ExclusionIpAddress <String[]>] [-RealTimeScanDirection]
  [-QuarantinePurgeItemsAfterDelay] [-RemediationScheduleDay] [-RemediationScheduleTime]
  [-ReportingAdditionalActionTimeOut] [-ReportingCriticalFailureTimeOut] [-ReportingNonCriticalTimeOut]
  [-ScanAvgCPULoadFactor] [-CheckForSignaturesBeforeRunningScan] [-ScanPurgeItemsAfterDelay]
  [-ScanOnlyIfIdleEnabled] [-ScanParameters] [-ScanScheduleDay] [-ScanScheduleQuickScanTime]
  [-ScanScheduleTime] [-SignatureFirstAuGracePeriod] [-SignatureAuGracePeriod] [-SignatureDefinitionUpdateFileSharesSources]
  [-SignatureDisableUpdateOnStartupWithoutEngine] [-SignatureFallbackOrder] [-SharedSignaturesPath]
  [-SignatureScheduleDay] [-SignatureScheduleTime] [-SignatureUpdateCatchupInterval]
  [-SignatureUpdateInterval] [-SignatureBlobUpdateInterval] [-SignatureBlobFileSharesSources]
  [-MeteredConnectionUpdates] [-AllowNetworkProtectionOnWinServer] [-DisableDatagramProcessing]
  [-DisableCpuThrottleOnIdleScans] [-MAPSReporting] [-SubmitSamplesConsent] [-DisableAutoExclusions]
  [-DisablePrivacyMode] [-RandomizeScheduleTaskTimes] [-SchedulerRandomizationTime]
  [-DisableBehaviorMonitoring] [-DisableIntrusionPreventionSystem] [-DisableIOAVProtection]
  [-DisableRealtimeMonitoring] [-DisableScriptScanning] [-DisableArchiveScanning]
  [-DisableCatchupFullScan] [-DisableCatchupQuickScan] [-DisableEmailScanning] [-DisableRemovableDriveScanning]
  [-DisableRestorePoint] [-DisableScanningMappedNetworkDrivesForFullScan] [-DisableScanningNetworkFiles]
  [-UILockdown] [-ThreatIDDefaultAction_Ids <Int64[]>] [-ThreatIDDefaultAction_Actions
  <ThreatAction[]>] [-UnknownThreatDefaultAction] [-LowThreatDefaultAction] [-ModerateThreatDefaultAction]
  [-HighThreatDefaultAction] [-SevereThreatDefaultAction] [-DisableBlockAtFirstSeen]
  [-PUAProtection] [-CloudBlockLevel] [-CloudExtendedTimeout] [-EnableNetworkProtection]
  [-EnableControlledFolderAccess] [-AttackSurfaceReductionOnlyExclusions <String[]>]
  [-ControlledFolderAccessAllowedApplications <String[]>] [-ControlledFolderAccessProtectedFolders
  <String[]>] [-AttackSurfaceReductionRules_Ids <String[]>] [-AttackSurfaceReductionRules_Actions
  <ASRRuleActionType[]>] [-EnableLowCpuPriority] [-EnableFileHashComputation] [-EnableFullScanOnBatteryPower]
  [-ProxyPacUrl] [-ProxyServer] [-ProxyBypass] [-ForceUseProxyOnly] [-DisableTlsParsing]
  [-DisableHttpParsing] [-DisableDnsParsing] [-DisableDnsOverTcpParsing] [-DisableSshParsing]
  [-PlatformUpdatesChannel] [-EngineUpdatesChannel] [-SignaturesUpdatesChannel] [-DisableGradualRelease]
  [-AllowNetworkProtectionDownLevel] [-AllowDatagramProcessingOnWinServer] [-EnableDnsSinkhole]
  [-DisableInboundConnectionFiltering] [-DisableRdpParsing] [-Force] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AllowDatagramProcessingOnWinServer,-adpows Switch: ~
  -AllowNetworkProtectionDownLevel,-anpdl Switch: ~
  -AllowNetworkProtectionOnWinServer,-anpws Switch: ~
  -AsJob Switch: ~
  -AttackSurfaceReductionOnlyExclusions String[]: ~
  -AttackSurfaceReductionRules_Actions ASRRuleActionType[]: ~
  -AttackSurfaceReductionRules_Ids String[]: ~
  -CheckForSignaturesBeforeRunningScan,-csbr Switch: ~
  -CimSession,-Session CimSession[]: ~
  -CloudBlockLevel Switch: ~
  -CloudExtendedTimeout,-cloudextimeout Switch: ~
  -ControlledFolderAccessAllowedApplications String[]: ~
  -ControlledFolderAccessProtectedFolders String[]: ~
  -DisableArchiveScanning,-darchsc Switch: ~
  -DisableAutoExclusions,-dae Switch: ~
  -DisableBehaviorMonitoring,-dbm Switch: ~
  -DisableBlockAtFirstSeen,-dbaf Switch: ~
  -DisableCatchupFullScan,-dcfsc Switch: ~
  -DisableCatchupQuickScan,-dcqsc Switch: ~
  -DisableCpuThrottleOnIdleScans Switch: ~
  -DisableDatagramProcessing,-ddtgp Switch: ~
  -DisableDnsOverTcpParsing,-ddnstcpp Switch: ~
  -DisableDnsParsing,-ddnsp Switch: ~
  -DisableEmailScanning,-demsc Switch: ~
  -DisableGradualRelease,-dgr Switch: ~
  -DisableHttpParsing,-dhttpp Switch: ~
  -DisableInboundConnectionFiltering,-dicf Switch: ~
  -DisableIntrusionPreventionSystem,-dips Switch: ~
  -DisableIOAVProtection,-dioavp Switch: ~
  -DisablePrivacyMode,-dpm Switch: ~
  -DisableRdpParsing,-drdpp Switch: ~
  -DisableRealtimeMonitoring,-drtm Switch: ~
  -DisableRemovableDriveScanning,-drdsc Switch: ~
  -DisableRestorePoint,-drp Switch: ~
  -DisableScanningMappedNetworkDrivesForFullScan,-dsmndfsc Switch: ~
  -DisableScanningNetworkFiles,-dsnf Switch: ~
  -DisableScriptScanning,-dscrptsc Switch: ~
  -DisableSshParsing,-dsshp Switch: ~
  -DisableTlsParsing,-dtlsp Switch: ~
  -EnableControlledFolderAccess Switch: ~
  -EnableDnsSinkhole,-ednss Switch: ~
  -EnableFileHashComputation,-efhc Switch: ~
  -EnableFullScanOnBatteryPower,-efsobp Switch: ~
  -EnableLowCpuPriority,-elcp Switch: ~
  -EnableNetworkProtection Switch: ~
  -EngineUpdatesChannel,-erelr Switch: ~
  -ExclusionExtension String[]: ~
  -ExclusionIpAddress String[]: ~
  -ExclusionPath String[]: ~
  -ExclusionProcess String[]: ~
  -Force Switch: ~
  -ForceUseProxyOnly,-fupo Switch: ~
  -HighThreatDefaultAction,-htdefac Switch: ~
  -LowThreatDefaultAction,-ltdefac Switch: ~
  -MAPSReporting Switch: ~
  -MeteredConnectionUpdates,-mcupd Switch: ~
  -ModerateThreatDefaultAction,-mtdefac Switch: ~
  -PlatformUpdatesChannel,-prelr Switch: ~
  -ProxyBypass,-proxbps Switch: ~
  -ProxyPacUrl,-ppurl Switch: ~
  -ProxyServer,-proxsrv Switch: ~
  -PUAProtection Switch: ~
  -QuarantinePurgeItemsAfterDelay,-qpiad Switch: ~
  -RandomizeScheduleTaskTimes,-rstt Switch: ~
  -RealTimeScanDirection,-rtsd Switch: ~
  -RemediationScheduleDay,-rsd Switch: ~
  -RemediationScheduleTime,-rst Switch: ~
  -ReportingAdditionalActionTimeOut,-raat Switch: ~
  -ReportingCriticalFailureTimeOut,-rcto Switch: ~
  -ReportingNonCriticalTimeOut,-rncto Switch: ~
  -ScanAvgCPULoadFactor,-saclf Switch: ~
  -ScanOnlyIfIdleEnabled,-soiie Switch: ~
  -ScanParameters Switch: ~
  -ScanPurgeItemsAfterDelay,-spiad Switch: ~
  -ScanScheduleDay,-scsd Switch: ~
  -ScanScheduleQuickScanTime,-scsqst Switch: ~
  -ScanScheduleTime,-scst Switch: ~
  -SchedulerRandomizationTime,-srt Switch: ~
  -SevereThreatDefaultAction,-stdefac Switch: ~
  -SharedSignaturesPath,-ssp,-SecurityIntelligenceLocation,-ssl Switch: ~
  -SignatureAuGracePeriod,-sigagp Switch: ~
  -SignatureBlobFileSharesSources,-sigbfs Switch: ~
  -SignatureBlobUpdateInterval,-sigbui Switch: ~
  -SignatureDefinitionUpdateFileSharesSources,-sigdufss Switch: ~
  -SignatureDisableUpdateOnStartupWithoutEngine,-sigduoswo Switch: ~
  -SignatureFallbackOrder,-sfo Switch: ~
  -SignatureFirstAuGracePeriod,-sigfagp Switch: ~
  -SignatureScheduleDay,-sigsd Switch: ~
  -SignatureScheduleTime,-sigst Switch: ~
  -SignaturesUpdatesChannel,-srelr Switch: ~
  -SignatureUpdateCatchupInterval,-siguci Switch: ~
  -SignatureUpdateInterval,-sigui Switch: ~
  -SubmitSamplesConsent Switch: ~
  -ThreatIDDefaultAction_Actions,-tiddefaca ThreatAction[]: ~
  -ThreatIDDefaultAction_Ids,-tiddefaci Int64[]: ~
  -ThrottleLimit Int32: ~
  -UILockdown Switch: ~
  -UnknownThreatDefaultAction,-unktdefac Switch: ~
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
