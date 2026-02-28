description: Modifies the properties of an existing BITS transfer job
synopses:
- Set-BitsTransfer [-BitsJob] <BitsJob[]> [-DisplayName <String>] [-Priority <String>]
  [-Description <String>] [-Dynamic] [-CustomHeadersWriteOnly] [-HttpMethod <String>]
  [-ProxyAuthentication <String>] [-RetryInterval <Int32>] [-RetryTimeout <Int32>]
  [-MaxDownloadTime <Int32>] [-TransferPolicy <CostStates>] [-ACLFlags <ACLFlagValue>]
  [-SecurityFlags <SecurityFlagValue>] [-UseStoredCredential <AuthenticationTargetValue>]
  [-Credential <PSCredential>] [-ProxyCredential <PSCredential>] [-Authentication
  <String>] [-SetOwnerToCurrentUser] [-ProxyUsage <String>] [-ProxyList <Uri[]>] [-ProxyBypass
  <String[]>] [-CustomHeaders <String[]>] [-NotifyFlags <NotifyFlagValue>] [-NotifyCmdLine
  <String[]>] [-CertStoreLocation <CertStoreLocationValue>] [-CertStoreName <String>]
  [-CertHash <Byte[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ACLFlags ACLFlagValue: ~
  -Authentication,-au String:
    values:
    - Basic
    - Digest
    - Ntlm
    - Negotiate
    - Passport
  -BitsJob,-b BitsJob[]:
    required: true
  -CertHash Byte[]: ~
  -CertStoreLocation CertStoreLocationValue: ~
  -CertStoreName String: ~
  -Confirm,-cf Switch: ~
  -Credential,-cred PSCredential: ~
  -CustomHeaders String[]: ~
  -CustomHeadersWriteOnly Switch: ~
  -Description,-d String: ~
  -DisplayName,-dn String: ~
  -Dynamic Switch: ~
  -HttpMethod,-hm String: ~
  -MaxDownloadTime Int32: ~
  -NotifyCmdLine String[]: ~
  -NotifyFlags NotifyFlagValue: ~
  -Priority,-p String:
    values:
    - Foreground
    - High
    - Normal
    - Low
  -ProxyAuthentication,-pa String:
    values:
    - Basic
    - Digest
    - Ntlm
    - Negotiate
    - Passport
  -ProxyBypass,-pb String[]: ~
  -ProxyCredential,-pc PSCredential: ~
  -ProxyList,-pl Uri[]: ~
  -ProxyUsage,-pu String:
    values:
    - SystemDefault
    - NoProxy
    - AutoDetect
    - Override
  -RetryInterval Int32: ~
  -RetryTimeout Int32: ~
  -SecurityFlags SecurityFlagValue: ~
  -SetOwnerToCurrentUser,-so Switch: ~
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
