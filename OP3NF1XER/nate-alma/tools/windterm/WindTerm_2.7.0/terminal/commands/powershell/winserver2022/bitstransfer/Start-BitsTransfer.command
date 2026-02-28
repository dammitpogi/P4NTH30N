description: Creates a BITS transfer job
synopses:
- Start-BitsTransfer [-Asynchronous] [-Dynamic] [-CustomHeadersWriteOnly] [-Authentication
  <String>] [-Credential <PSCredential>] [-Description <String>] [-HttpMethod <String>]
  [[-Destination] <String[]>] [-DisplayName <String>] [-Priority <String>] [-TransferPolicy
  <CostStates>] [-ACLFlags <ACLFlagValue>] [-SecurityFlags <SecurityFlagValue>] [-UseStoredCredential
  <AuthenticationTargetValue>] [-ProxyAuthentication <String>] [-ProxyBypass <String[]>]
  [-ProxyCredential <PSCredential>] [-ProxyList <Uri[]>] [-ProxyUsage <String>] [-RetryInterval
  <Int32>] [-RetryTimeout <Int32>] [-MaxDownloadTime <Int32>] [-Source] <String[]>
  [-Suspended] [-TransferType <String>] [-CustomHeaders <String[]>] [-NotifyFlags
  <NotifyFlagValue>] [-NotifyCmdLine <String[]>] [-CertStoreLocation <CertStoreLocationValue>]
  [-CertStoreName <String>] [-CertHash <Byte[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ACLFlags ACLFlagValue: ~
  -Asynchronous Switch: ~
  -Authentication String:
    values:
    - Basic
    - Digest
    - Ntlm
    - Negotiate
    - Passport
  -CertHash Byte[]: ~
  -CertStoreLocation CertStoreLocationValue: ~
  -CertStoreName String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -CustomHeaders String[]: ~
  -CustomHeadersWriteOnly Switch: ~
  -Description String: ~
  -Destination String[]: ~
  -DisplayName String: ~
  -Dynamic Switch: ~
  -HttpMethod String: ~
  -MaxDownloadTime Int32: ~
  -NotifyCmdLine String[]: ~
  -NotifyFlags NotifyFlagValue: ~
  -Priority String:
    values:
    - Foreground
    - High
    - Normal
    - Low
  -ProxyAuthentication String:
    values:
    - Basic
    - Digest
    - Ntlm
    - Negotiate
    - Passport
  -ProxyBypass String[]: ~
  -ProxyCredential PSCredential: ~
  -ProxyList Uri[]: ~
  -ProxyUsage String:
    values:
    - SystemDefault
    - NoProxy
    - AutoDetect
    - Override
  -RetryInterval Int32: ~
  -RetryTimeout Int32: ~
  -SecurityFlags SecurityFlagValue: ~
  -Source String[]:
    required: true
  -Suspended Switch: ~
  -TransferPolicy CostStates:
    values:
    - None
    - Unrestricted
    - Capped
    - BelowCap
    - NearCap
    - OverCapCharged
    - OverCapThrottled
    - UsageBased
    - Roaming
    - IgnoreCongestion
    - PolicyUnrestricted
    - Standard
    - NoSurcharge
    - NotRoaming
    - Always
  -TransferType String:
    values:
    - Download
    - Upload
    - UploadReply
  -UseStoredCredential AuthenticationTargetValue:
    values:
    - None
    - Server
    - Proxy
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
