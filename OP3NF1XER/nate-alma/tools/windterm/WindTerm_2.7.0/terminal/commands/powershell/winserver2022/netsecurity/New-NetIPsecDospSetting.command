description: Creates an IPsec DoS protection setting and adds the setting to the target
  computer
synopses:
- New-NetIPsecDospSetting -Name <String> [-StateIdleTimeoutSeconds <UInt32>] [-PerIPRateLimitQueueIdleTimeoutSeconds
  <UInt32>] [-IpV6IPsecUnauthDscp <UInt32>] [-IpV6IPsecUnauthRateLimitBytesPerSec
  <UInt32>] [-IpV6IPsecUnauthPerIPRateLimitBytesPerSec <UInt32>] [-IpV6IPsecAuthDscp
  <UInt16>] [-IpV6IPsecAuthRateLimitBytesPerSec <UInt32>] [-IcmpV6Dscp <UInt16>] [-IcmpV6RateLimitBytesPerSec
  <UInt32>] [-IpV6FilterExemptDscp <UInt32>] [-IpV6FilterExemptRateLimitBytesPerSec
  <UInt32>] [-DefBlockExemptDscp <UInt16>] [-DefBlockExemptRateLimitBytesPerSec <UInt32>]
  [-MaxStateEntries <UInt32>] [-MaxPerIPRateLimitQueues <UInt32>] [-EnabledKeyingModules
  <DospKeyModules>] [-FilteringFlags <DospFlags>] -PublicInterfaceAliases <WildcardPattern[]>
  -PrivateInterfaceAliases <WildcardPattern[]> [-PublicV6Address <String>] [-PrivateV6Address
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DefBlockExemptDscp UInt16: ~
  -DefBlockExemptRateLimitBytesPerSec UInt32: ~
  -EnabledKeyingModules DospKeyModules:
    values:
    - None
    - IkeV1
    - IkeV2
    - AuthIP
  -FilteringFlags DospFlags:
    values:
    - None
    - DisableDefaultBlock
    - FilterBlock
    - FilterExempt
  -IcmpV6Dscp UInt16: ~
  -IcmpV6RateLimitBytesPerSec UInt32: ~
  -IpV6FilterExemptDscp UInt32: ~
  -IpV6FilterExemptRateLimitBytesPerSec UInt32: ~
  -IpV6IPsecAuthDscp UInt16: ~
  -IpV6IPsecAuthRateLimitBytesPerSec UInt32: ~
  -IpV6IPsecUnauthDscp UInt32: ~
  -IpV6IPsecUnauthPerIPRateLimitBytesPerSec UInt32: ~
  -IpV6IPsecUnauthRateLimitBytesPerSec UInt32: ~
  -MaxPerIPRateLimitQueues UInt32: ~
  -MaxStateEntries UInt32: ~
  -Name String:
    required: true
  -PerIPRateLimitQueueIdleTimeoutSeconds UInt32: ~
  -PrivateInterfaceAliases WildcardPattern[]:
    required: true
  -PrivateV6Address String: ~
  -PublicInterfaceAliases WildcardPattern[]:
    required: true
  -PublicV6Address String: ~
  -StateIdleTimeoutSeconds UInt32: ~
  -ThrottleLimit Int32: ~
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
