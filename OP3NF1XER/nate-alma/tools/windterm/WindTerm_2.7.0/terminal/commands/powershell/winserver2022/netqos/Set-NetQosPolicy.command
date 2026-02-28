description: Updates the QoS policy settings
synopses:
- Set-NetQosPolicy [[-Name] <String[]>] [-PolicyStore <String>] [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] [-TemplateMatchCondition <Template>] [-UserMatchCondition
  <String>] [-AppPathNameMatchCondition <String>] [-IPProtocolMatchCondition <Protocol>]
  [-IPPortMatchCondition <UInt16>] [-IPSrcPrefixMatchCondition <String>] [-IPSrcPortMatchCondition
  <UInt16>] [-IPSrcPortStartMatchCondition <UInt16>] [-IPSrcPortEndMatchCondition
  <UInt16>] [-IPDstPrefixMatchCondition <String>] [-IPDstPortMatchCondition <UInt16>]
  [-IPDstPortStartMatchCondition <UInt16>] [-IPDstPortEndMatchCondition <UInt16>]
  [-NetDirectPortMatchCondition <UInt16>] [-URIMatchCondition <String>] [-URIRecursiveMatchCondition
  <Boolean>] [-PriorityValue8021Action <SByte>] [-DSCPAction <SByte>] [-MinBandwidthWeightAction
  <Byte>] [-ThrottleRateActionBitsPerSecond <UInt64>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetQosPolicy -InputObject <CimInstance[]> [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] [-TemplateMatchCondition <Template>] [-UserMatchCondition
  <String>] [-AppPathNameMatchCondition <String>] [-IPProtocolMatchCondition <Protocol>]
  [-IPPortMatchCondition <UInt16>] [-IPSrcPrefixMatchCondition <String>] [-IPSrcPortMatchCondition
  <UInt16>] [-IPSrcPortStartMatchCondition <UInt16>] [-IPSrcPortEndMatchCondition
  <UInt16>] [-IPDstPrefixMatchCondition <String>] [-IPDstPortMatchCondition <UInt16>]
  [-IPDstPortStartMatchCondition <UInt16>] [-IPDstPortEndMatchCondition <UInt16>]
  [-NetDirectPortMatchCondition <UInt16>] [-URIMatchCondition <String>] [-URIRecursiveMatchCondition
  <Boolean>] [-PriorityValue8021Action <SByte>] [-DSCPAction <SByte>] [-MinBandwidthWeightAction
  <Byte>] [-ThrottleRateActionBitsPerSecond <UInt64>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AppPathNameMatchCondition,-AppPathName,-ApplicationName,-app String: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DSCPAction,-DSCPValue,-DSCP SByte: ~
  -IPDstPortEndMatchCondition,-IPDstPortEnd UInt16: ~
  -IPDstPortMatchCondition,-IPDstPort,-DestinationPort,-dp,-dstport,-destport UInt16: ~
  -IPDstPortStartMatchCondition,-IPDstPortStart UInt16: ~
  -IPDstPrefixMatchCondition,-IPDstPrefix,-DestinationAddress,-da,-dst,-dstaddr,-dstip,-dest,-destaddr,-destip String: ~
  -IPPortMatchCondition,-IPPort,-port UInt16: ~
  -IPProtocolMatchCondition,-IPProtocol,-Protocol Protocol:
    values:
    - None
    - TCP
    - UDP
    - Both
  -IPSrcPortEndMatchCondition,-IPSrcPortEnd UInt16: ~
  -IPSrcPortMatchCondition,-IPSrcPort,-SourcePort,-sp,-srcport UInt16: ~
  -IPSrcPortStartMatchCondition,-IPSrcPortStart UInt16: ~
  -IPSrcPrefixMatchCondition,-IPSrcPrefix,-SourceAddress,-sa,-src,-srcaddr,-srcip String: ~
  -InputObject CimInstance[]:
    required: true
  -MinBandwidthWeightAction,-MinBandwidthWeight,-minbww,-weight Byte: ~
  -Name String[]: ~
  -NetDirectPortMatchCondition,-NetDirectPort,-ndport,-networkdirectport UInt16: ~
  -NetworkProfile NetworkProfile:
    values:
    - Domain
    - Public
    - Private
    - All
  -PassThru Switch: ~
  -PolicyStore,-store String: ~
  -Precedence UInt32: ~
  -PriorityValue8021Action,-PriorityValue,-PriorityValue8021,-pri,-dot1p SByte: ~
  -TemplateMatchCondition,-Template Template:
    values:
    - None
    - Default
    - iSCSI
    - FCoE
    - SMB
    - NFS
    - LiveMigration
    - Cluster
  -ThrottleLimit Int32: ~
  -ThrottleRateActionBitsPerSecond,-ThrottleRateAction,-ThrottleRate,-Throttle,-maxbw UInt64: ~
  -URIMatchCondition,-URI,-url String: ~
  -URIRecursiveMatchCondition,-URIRecursive,-urlrecursive,-recursive Boolean: ~
  -UserMatchCondition,-User,-sid String: ~
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
