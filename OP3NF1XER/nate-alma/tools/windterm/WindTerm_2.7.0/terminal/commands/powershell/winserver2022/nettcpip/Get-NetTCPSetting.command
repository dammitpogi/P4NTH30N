description: Gets information about TCP settings and configuration
synopses:
- Get-NetTCPSetting [[-SettingName] <String[]>] [-MinRtoMs <UInt32[]>] [-InitialCongestionWindowMss
  <UInt32[]>] [-CongestionProvider <CongestionProvider[]>] [-CwndRestart <CwndRestart[]>]
  [-DelayedAckTimeoutMs <UInt32[]>] [-DelayedAckFrequency <Byte[]>] [-MemoryPressureProtection
  <MemoryPressureProtection[]>] [-AutoTuningLevelLocal <AutoTuningLevelLocal[]>] [-AutoTuningLevelGroupPolicy
  <AutoTuningLevelGroupPolicy[]>] [-AutoTuningLevelEffective <AutoTuningLevelEffective[]>]
  [-EcnCapability <EcnCapability[]>] [-Timestamps <Timestamps[]>] [-InitialRtoMs <UInt32[]>]
  [-ScalingHeuristics <ScalingHeuristics[]>] [-DynamicPortRangeStartPort <UInt16[]>]
  [-DynamicPortRangeNumberOfPorts <UInt16[]>] [-AutomaticUseCustom <AutomaticUseCustom[]>]
  [-NonSackRttResiliency <NonSackRttResiliency[]>] [-ForceWS <ForceWS[]>] [-MaxSynRetransmissions
  <Byte[]>] [-AutoReusePortRangeStartPort <UInt16[]>] [-AutoReusePortRangeNumberOfPorts
  <UInt16[]>] [-AssociatedTransportFilter <CimInstance>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AssociatedTransportFilter CimInstance: ~
  -AutoReusePortRangeNumberOfPorts UInt16[]: ~
  -AutoReusePortRangeStartPort UInt16[]: ~
  -AutoTuningLevelEffective AutoTuningLevelEffective[]:
    values:
    - Local
    - GroupPolicy
  -AutoTuningLevelGroupPolicy AutoTuningLevelGroupPolicy[]:
    values:
    - Disabled
    - HighlyRestricted
    - Restricted
    - Normal
    - Experimental
    - NotConfigured
    - NotChanged
  -AutoTuningLevelLocal AutoTuningLevelLocal[]:
    values:
    - Disabled
    - HighlyRestricted
    - Restricted
    - Normal
    - Experimental
  -AutomaticUseCustom AutomaticUseCustom[]:
    values:
    - Disabled
    - Enabled
  -CimSession,-Session CimSession[]: ~
  -CongestionProvider CongestionProvider[]:
    values:
    - Default
    - CTCP
    - DCTCP
  -CwndRestart CwndRestart[]:
    values:
    - 'False'
    - 'True'
  -DelayedAckFrequency Byte[]: ~
  -DelayedAckTimeoutMs,-DelayedAckTimeout UInt32[]: ~
  -DynamicPortRangeNumberOfPorts UInt16[]: ~
  -DynamicPortRangeStartPort UInt16[]: ~
  -EcnCapability EcnCapability[]:
    values:
    - Disabled
    - Enabled
  -ForceWS ForceWS[]:
    values:
    - Disabled
    - Enabled
  -InitialCongestionWindowMss,-InitialCongestionWindow UInt32[]: ~
  -InitialRtoMs,-InitialRto UInt32[]: ~
  -MaxSynRetransmissions Byte[]: ~
  -MemoryPressureProtection MemoryPressureProtection[]:
    values:
    - Disabled
    - Enabled
    - Default
  -MinRtoMs,-MinRto UInt32[]: ~
  -NonSackRttResiliency NonSackRttResiliency[]:
    values:
    - Disabled
    - Enabled
  -ScalingHeuristics ScalingHeuristics[]:
    values:
    - Disabled
    - Enabled
  -SettingName String[]: ~
  -ThrottleLimit Int32: ~
  -Timestamps Timestamps[]:
    values:
    - Disabled
    - Enabled
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
