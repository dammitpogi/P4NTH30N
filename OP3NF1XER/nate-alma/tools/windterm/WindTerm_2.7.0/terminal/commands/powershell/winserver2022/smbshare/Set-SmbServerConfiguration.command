description: Sets the Server Message Block (SMB) server configuration
synopses:
- Set-SmbServerConfiguration [-AnnounceComment <String>] [-AnnounceServer <Boolean>]
  [-AsynchronousCredits <UInt32>] [-AuditSmb1Access <Boolean>] [-AutoDisconnectTimeout
  <UInt32>] [-AutoShareServer <Boolean>] [-AutoShareWorkstation <Boolean>] [-CachedOpenLimit
  <UInt32>] [-DisableSmbEncryptionOnSecureConnection <Boolean>] [-DurableHandleV2TimeoutInSeconds
  <UInt32>] [-EnableAuthenticateUserSharing <Boolean>] [-EnableDownlevelTimewarp <Boolean>]
  [-EnableForcedLogoff <Boolean>] [-EnableLeasing <Boolean>] [-EnableMultiChannel
  <Boolean>] [-EnableOplocks <Boolean>] [-EnableSecuritySignature <Boolean>] [-EnableSMB1Protocol
  <Boolean>] [-EnableSMB2Protocol <Boolean>] [-EnableSMBQUIC <Boolean>] [-EnableStrictNameChecking
  <Boolean>] [-EncryptData <Boolean>] [-IrpStackSize <UInt32>] [-KeepAliveTime <UInt32>]
  [-MaxChannelPerSession <UInt32>] [-MaxMpxCount <UInt32>] [-MaxSessionPerConnection
  <UInt32>] [-MaxThreadsPerQueue <UInt32>] [-MaxWorkItems <UInt32>] [-NullSessionPipes
  <String>] [-NullSessionShares <String>] [-OplockBreakWait <UInt32>] [-PendingClientTimeoutInSeconds
  <UInt32>] [-RejectUnencryptedAccess <Boolean>] [-RequireSecuritySignature <Boolean>]
  [-ServerHidden <Boolean>] [-Smb2CreditsMax <UInt32>] [-Smb2CreditsMin <UInt32>]
  [-SmbServerNameHardeningLevel <UInt32>] [-TreatHostAsStableStorage <Boolean>] [-ValidateAliasNotCircular
  <Boolean>] [-ValidateShareScope <Boolean>] [-ValidateShareScopeNotAliased <Boolean>]
  [-ValidateTargetName <Boolean>] [-RestrictNamedpipeAccessViaQuic <Boolean>] [-Force]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AnnounceComment String: ~
  -AnnounceServer Boolean: ~
  -AsJob Switch: ~
  -AsynchronousCredits UInt32: ~
  -AuditSmb1Access Boolean: ~
  -AutoDisconnectTimeout UInt32: ~
  -AutoShareServer Boolean: ~
  -AutoShareWorkstation Boolean: ~
  -CachedOpenLimit UInt32: ~
  -CimSession,-Session CimSession[]: ~
  -DisableSmbEncryptionOnSecureConnection Boolean: ~
  -DurableHandleV2TimeoutInSeconds UInt32: ~
  -EnableAuthenticateUserSharing Boolean: ~
  -EnableDownlevelTimewarp Boolean: ~
  -EnableForcedLogoff Boolean: ~
  -EnableLeasing Boolean: ~
  -EnableMultiChannel Boolean: ~
  -EnableOplocks Boolean: ~
  -EnableSecuritySignature Boolean: ~
  -EnableSMB1Protocol Boolean: ~
  -EnableSMB2Protocol Boolean: ~
  -EnableSMBQUIC Boolean: ~
  -EnableStrictNameChecking Boolean: ~
  -EncryptData Boolean: ~
  -Force Switch: ~
  -IrpStackSize UInt32: ~
  -KeepAliveTime UInt32: ~
  -MaxChannelPerSession UInt32: ~
  -MaxMpxCount UInt32: ~
  -MaxSessionPerConnection UInt32: ~
  -MaxThreadsPerQueue UInt32: ~
  -MaxWorkItems UInt32: ~
  -NullSessionPipes String: ~
  -NullSessionShares String: ~
  -OplockBreakWait UInt32: ~
  -PendingClientTimeoutInSeconds UInt32: ~
  -RejectUnencryptedAccess Boolean: ~
  -RequireSecuritySignature Boolean: ~
  -RestrictNamedpipeAccessViaQuic Boolean: ~
  -ServerHidden Boolean: ~
  -Smb2CreditsMax UInt32: ~
  -Smb2CreditsMin UInt32: ~
  -SmbServerNameHardeningLevel UInt32: ~
  -ThrottleLimit Int32: ~
  -TreatHostAsStableStorage Boolean: ~
  -ValidateAliasNotCircular Boolean: ~
  -ValidateShareScope Boolean: ~
  -ValidateShareScopeNotAliased Boolean: ~
  -ValidateTargetName Boolean: ~
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
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
