description: Changes configuration settings for an NFS server
synopses:
- Set-NfsServerConfiguration [-InputObject <CimInstance[]>] [-PortmapProtocol <String[]>]
  [-MountProtocol <String[]>] [-Nfsprotocol <String[]>] [-NlmProtocol <String[]>]
  [-NsmProtocol <String[]>] [-MapServerProtocol <String[]>] [-NisProtocol <String[]>]
  [-EnableNFSV2 <Boolean>] [-EnableNFSV3 <Boolean>] [-EnableNFSV4 <Boolean>] [-EnableAuthenticationRenewal
  <Boolean>] [-AuthenticationRenewalIntervalSec <UInt32>] [-DirectoryCacheSize <UInt32>]
  [-CharacterTranslationFile <String>] [-HideFilesBeginningInDot <Boolean>] [-NlmGracePeriodSec
  <UInt32>] [-LogActivity <String[]>] [-GracePeriodSec <UInt32>] [-NetgroupCacheTimeoutSec
  <UInt32>] [-PreserveInheritance <Boolean>] [-UnmappedUserAccount <String>] [-WorldAccount
  <String>] [-AlwaysOpenByName <Boolean>] [-LeasePeriodSec <UInt32>] [-ClearMappingCache]
  [-OnlineTimeoutSec <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AlwaysOpenByName,-OpenByName Boolean: ~
  -AsJob Switch: ~
  -AuthenticationRenewalIntervalSec,-interval,-renewauthinterval,-AuthRenewalInterval,-AuthenticationRenewalInterval UInt32: ~
  -CharacterTranslationFile,-translationfile String: ~
  -CimSession,-Session CimSession[]: ~
  -ClearMappingCache,-clearmapcache Switch: ~
  -Confirm,-cf Switch: ~
  -DirectoryCacheSize,-dircache,-dcache UInt32: ~
  -EnableAuthenticationRenewal,-renewauth,-EnableAuthRenewal Boolean: ~
  -EnableNFSV2,-v2,-nfsv2 Boolean: ~
  -EnableNFSV3,-v3,-nfsv3 Boolean: ~
  -EnableNFSV4,-v4,-nfsv4 Boolean: ~
  -GracePeriodSec,-nfsv4graceperiod,-GracePeriod UInt32: ~
  -HideFilesBeginningInDot,-hidedotfiles,-dotfileshidden Boolean: ~
  -InputObject CimInstance[]: ~
  -LeasePeriodSec,-Lease,-LeasePeriod UInt32: ~
  -LogActivity,-audit String[]:
    values:
    - mount
    - unmount
    - read
    - write
    - create
    - delete
    - lock
    - unlock
    - none
    - all
  -MapServerProtocol,-MapsvrProtocol String[]:
    values:
    - tcp
    - udp
  -MountProtocol String[]:
    values:
    - tcp
    - udp
  -NetgroupCacheTimeoutSec,-NetgroupTimeout,-NetgroupCacheTimeout UInt32: ~
  -Nfsprotocol String[]:
    values:
    - tcp
    - udp
  -NisProtocol String[]:
    values:
    - tcp
    - udp
  -NlmGracePeriodSec,-lockperiod,-nlmgrace,-NlmGracePeriod UInt32: ~
  -NlmProtocol String[]:
    values:
    - tcp
    - udp
  -NsmProtocol String[]:
    values:
    - tcp
    - udp
  -OnlineTimeoutSec,-onlinetimeout,-OnlineTimeoutInSeconds UInt32: ~
  -PassThru Switch: ~
  -PortmapProtocol String[]:
    values:
    - tcp
    - udp
  -PreserveInheritance,-Inheritance Boolean: ~
  -ThrottleLimit Int32: ~
  -UnmappedUserAccount,-UnmappedAccount String: ~
  -WhatIf,-wi Switch: ~
  -WorldAccount,-World String: ~
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
