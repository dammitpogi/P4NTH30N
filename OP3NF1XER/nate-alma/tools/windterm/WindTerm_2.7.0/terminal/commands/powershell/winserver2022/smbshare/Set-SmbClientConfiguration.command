description: Sets the SMB client configuration
synopses:
- Set-SmbClientConfiguration [-SkipCertificateCheck <Boolean>] [-ConnectionCountPerRssNetworkInterface
  <UInt32>] [-DirectoryCacheEntriesMax <UInt32>] [-DirectoryCacheEntrySizeMax <UInt32>]
  [-DirectoryCacheLifetime <UInt32>] [-DormantFileLimit <UInt32>] [-EnableBandwidthThrottling
  <Boolean>] [-EnableByteRangeLockingOnReadOnlyFiles <Boolean>] [-EnableInsecureGuestLogons
  <Boolean>] [-EnableLargeMtu <Boolean>] [-EnableLoadBalanceScaleOut <Boolean>] [-EnableMultiChannel
  <Boolean>] [-EnableSecuritySignature <Boolean>] [-ExtendedSessionTimeout <UInt32>]
  [-FileInfoCacheEntriesMax <UInt32>] [-FileInfoCacheLifetime <UInt32>] [-FileNotFoundCacheEntriesMax
  <UInt32>] [-FileNotFoundCacheLifetime <UInt32>] [-ForceSMBEncryptionOverQuic <Boolean>]
  [-KeepConn <UInt32>] [-MaxCmds <UInt32>] [-MaximumConnectionCountPerServer <UInt32>]
  [-OplocksDisabled <Boolean>] [-RequireSecuritySignature <Boolean>] [-SessionTimeout
  <UInt32>] [-UseOpportunisticLocking <Boolean>] [-WindowSizeThreshold <UInt32>] [-DisableCompression
  <Boolean>] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ConnectionCountPerRssNetworkInterface UInt32: ~
  -DirectoryCacheEntriesMax UInt32: ~
  -DirectoryCacheEntrySizeMax UInt32: ~
  -DirectoryCacheLifetime UInt32: ~
  -DisableCompression Boolean: ~
  -DormantFileLimit UInt32: ~
  -EnableBandwidthThrottling Boolean: ~
  -EnableByteRangeLockingOnReadOnlyFiles Boolean: ~
  -EnableInsecureGuestLogons Boolean: ~
  -EnableLargeMtu Boolean: ~
  -EnableLoadBalanceScaleOut Boolean: ~
  -EnableMultiChannel Boolean: ~
  -EnableSecuritySignature Boolean: ~
  -ExtendedSessionTimeout UInt32: ~
  -FileInfoCacheEntriesMax UInt32: ~
  -FileInfoCacheLifetime UInt32: ~
  -FileNotFoundCacheEntriesMax UInt32: ~
  -FileNotFoundCacheLifetime UInt32: ~
  -Force Switch: ~
  -ForceSMBEncryptionOverQuic Boolean: ~
  -KeepConn UInt32: ~
  -MaxCmds UInt32: ~
  -MaximumConnectionCountPerServer UInt32: ~
  -OplocksDisabled Boolean: ~
  -RequireSecuritySignature Boolean: ~
  -SessionTimeout UInt32: ~
  -SkipCertificateCheck Boolean: ~
  -ThrottleLimit Int32: ~
  -UseOpportunisticLocking Boolean: ~
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
  -WindowSizeThreshold UInt32: ~
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
