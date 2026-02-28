description: Modifies the IPv6 protocol configuration
synopses:
- Set-NetIPv6Protocol [-InputObject <CimInstance[]>] [-DefaultHopLimit <UInt32>] [-NeighborCacheLimitEntries
  <UInt32>] [-RouteCacheLimitEntries <UInt32>] [-ReassemblyLimitBytes <UInt32>] [-IcmpRedirects
  <IcmpRedirects>] [-SourceRoutingBehavior <SourceRoutingBehavior>] [-DhcpMediaSense
  <DhcpMediaSense>] [-MediaSenseEventLog <MediaSenseEventLog>] [-MldLevel <MldLevel>]
  [-MldVersion <MldVersion>] [-MulticastForwarding <MulticastForwarding>] [-GroupForwardedFragments
  <GroupForwardedFragments>] [-RandomizeIdentifiers <RandomizeIdentifiers>] [-AddressMaskReply
  <AddressMaskReply>] [-DeadGatewayDetection <DeadGatewayDetection>] [-UseTemporaryAddresses
  <UseTemporaryAddresses>] [-MaxTemporaryDadAttempts <UInt32>] [-MaxTemporaryValidLifetime
  <TimeSpan>] [-MaxTemporaryPreferredLifetime <TimeSpan>] [-TemporaryRegenerateTime
  <TimeSpan>] [-MaxTemporaryDesyncTime <TimeSpan>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressMaskReply AddressMaskReply:
    values:
    - Disabled
    - Enabled
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DeadGatewayDetection DeadGatewayDetection: ~
  -DefaultHopLimit UInt32: ~
  -DhcpMediaSense DhcpMediaSense:
    values:
    - Disabled
    - Enabled
  -GroupForwardedFragments GroupForwardedFragments:
    values:
    - Disabled
    - Enabled
  -IcmpRedirects IcmpRedirects:
    values:
    - Disabled
    - Enabled
  -InputObject CimInstance[]: ~
  -MaxTemporaryDadAttempts,-MaxDadAttempts UInt32: ~
  -MaxTemporaryDesyncTime,-MaxRandomTime TimeSpan: ~
  -MaxTemporaryPreferredLifetime,-MaxPreferredLifetime TimeSpan: ~
  -MaxTemporaryValidLifetime,-MaxValidLifetime TimeSpan: ~
  -MediaSenseEventLog MediaSenseEventLog:
    values:
    - Disabled
    - Enabled
  -MldLevel MldLevel:
    values:
    - None
    - SendOnly
    - All
  -MldVersion MldVersion:
    values:
    - Version1
    - Version2
  -MulticastForwarding MulticastForwarding:
    values:
    - Disabled
    - Enabled
  -NeighborCacheLimitEntries,-NeighborCacheLimit UInt32: ~
  -PassThru Switch: ~
  -RandomizeIdentifiers RandomizeIdentifiers:
    values:
    - Disabled
    - Enabled
  -ReassemblyLimitBytes,-ReassemblyLimit UInt32: ~
  -RouteCacheLimitEntries,-RouteCacheLimit UInt32: ~
  -SourceRoutingBehavior SourceRoutingBehavior:
    values:
    - Forward
    - DontForward
    - Drop
  -TemporaryRegenerateTime,-RegenerateTime TimeSpan: ~
  -ThrottleLimit Int32: ~
  -UseTemporaryAddresses UseTemporaryAddresses:
    values:
    - Disabled
    - Enabled
    - Always
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
