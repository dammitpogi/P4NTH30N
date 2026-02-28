description: Modifies information about the IPv4 Protocol configuration
synopses:
- Set-NetIPv4Protocol [-InputObject <CimInstance[]>] [-DefaultHopLimit <UInt32>] [-NeighborCacheLimitEntries
  <UInt32>] [-RouteCacheLimitEntries <UInt32>] [-ReassemblyLimitBytes <UInt32>] [-IcmpRedirects
  <IcmpRedirects>] [-SourceRoutingBehavior <SourceRoutingBehavior>] [-DhcpMediaSense
  <DhcpMediaSense>] [-MediaSenseEventLog <MediaSenseEventLog>] [-IGMPLevel <MldLevel>]
  [-IGMPVersion <MldVersion>] [-MulticastForwarding <MulticastForwarding>] [-GroupForwardedFragments
  <GroupForwardedFragments>] [-RandomizeIdentifiers <RandomizeIdentifiers>] [-AddressMaskReply
  <AddressMaskReply>] [-DeadGatewayDetection <DeadGatewayDetection>] [-MinimumMtu
  <UInt32>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
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
  -IGMPLevel,-MldLevel MldLevel:
    values:
    - None
    - SendOnly
    - All
  -IGMPVersion,-MldVersion MldVersion:
    values:
    - Version1
    - Version2
    - Version3
  -IcmpRedirects IcmpRedirects:
    values:
    - Disabled
    - Enabled
  -InputObject CimInstance[]: ~
  -MediaSenseEventLog MediaSenseEventLog:
    values:
    - Disabled
    - Enabled
  -MinimumMtu UInt32: ~
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
