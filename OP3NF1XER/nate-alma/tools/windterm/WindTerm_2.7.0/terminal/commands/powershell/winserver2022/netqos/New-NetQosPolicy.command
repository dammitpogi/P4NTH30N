description: Creates a new network QoS policy
synopses:
- New-NetQosPolicy [-PolicyStore <String>] [-Name] <String> [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] [-PriorityValue8021Action <SByte>] [-DSCPAction <SByte>]
  [-MinBandwidthWeightAction <Byte>] [-ThrottleRateActionBitsPerSecond <UInt64>] [-IPDstPrefixMatchCondition
  <String>] [-UserMatchCondition <String>] [-AppPathNameMatchCondition <String>] [-IPProtocolMatchCondition
  <Protocol>] [-IPSrcPrefixMatchCondition <String>] [-IPSrcPortMatchCondition <UInt16>]
  [-IPSrcPortStartMatchCondition <UInt16>] [-IPSrcPortEndMatchCondition <UInt16>]
  [-IPDstPortMatchCondition <UInt16>] [-IPDstPortStartMatchCondition <UInt16>] [-IPDstPortEndMatchCondition
  <UInt16>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- New-NetQosPolicy [-PolicyStore <String>] [-Name] <String> [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] [-PriorityValue8021Action <SByte>] [-DSCPAction <SByte>]
  [-MinBandwidthWeightAction <Byte>] [-ThrottleRateActionBitsPerSecond <UInt64>] [-UserMatchCondition
  <String>] [-AppPathNameMatchCondition <String>] [-IPProtocolMatchCondition <Protocol>]
  -IPPortMatchCondition <UInt16> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-NetQosPolicy [-PolicyStore <String>] [-Name] <String> [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] -PriorityValue8021Action <SByte> -NetDirectPortMatchCondition
  <UInt16> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- New-NetQosPolicy [-PolicyStore <String>] [-Name] <String> [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] [-DSCPAction <SByte>] [-ThrottleRateActionBitsPerSecond <UInt64>]
  -URIMatchCondition <String> [-URIRecursiveMatchCondition <Boolean>] [-IPDstPrefixMatchCondition
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- New-NetQosPolicy [-PolicyStore <String>] [-Name] <String> [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] [-PriorityValue8021Action <SByte>] [-DSCPAction <SByte>]
  [-MinBandwidthWeightAction <Byte>] [-ThrottleRateActionBitsPerSecond <UInt64>] [-Cluster]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- New-NetQosPolicy [-PolicyStore <String>] [-Name] <String> [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] [-PriorityValue8021Action <SByte>] [-DSCPAction <SByte>]
  [-MinBandwidthWeightAction <Byte>] [-ThrottleRateActionBitsPerSecond <UInt64>] [-SMB]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- New-NetQosPolicy [-PolicyStore <String>] [-Name] <String> [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] [-PriorityValue8021Action <SByte>] [-DSCPAction <SByte>]
  [-MinBandwidthWeightAction <Byte>] [-ThrottleRateActionBitsPerSecond <UInt64>] [-NFS]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- New-NetQosPolicy [-PolicyStore <String>] [-Name] <String> [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] [-PriorityValue8021Action <SByte>] [-DSCPAction <SByte>]
  [-MinBandwidthWeightAction <Byte>] [-ThrottleRateActionBitsPerSecond <UInt64>] [-LiveMigration]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- New-NetQosPolicy [-PolicyStore <String>] [-Name] <String> [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] [-PriorityValue8021Action <SByte>] [-DSCPAction <SByte>]
  [-MinBandwidthWeightAction <Byte>] [-ThrottleRateActionBitsPerSecond <UInt64>] [-iSCSI]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- New-NetQosPolicy [-PolicyStore <String>] [-Name] <String> [-NetworkProfile <NetworkProfile>]
  [-Precedence <UInt32>] -PriorityValue8021Action <SByte> [-FCOE] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- New-NetQosPolicy [-PolicyStore <String>] [-Name] <String> [-Default] [-NetworkProfile
  <NetworkProfile>] [-Precedence <UInt32>] [-PriorityValue8021Action <SByte>] [-DSCPAction
  <SByte>] [-MinBandwidthWeightAction <Byte>] [-ThrottleRateActionBitsPerSecond <UInt64>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AppPathNameMatchCondition,-AppPathName,-ApplicationName,-app String: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Cluster Switch:
    required: true
  -Confirm,-cf Switch: ~
  -DSCPAction,-DSCPValue,-DSCP SByte: ~
  -Default Switch:
    required: true
  -FCOE Switch:
    required: true
  -IPDstPortEndMatchCondition,-IPDstPortEnd UInt16: ~
  -IPDstPortMatchCondition,-IPDstPort,-DestinationPort,-dp,-dstport,-destport UInt16: ~
  -IPDstPortStartMatchCondition,-IPDstPortStart UInt16: ~
  -IPDstPrefixMatchCondition,-IPDstPrefix,-DestinationAddress,-da,-dst,-dstaddr,-dstip,-dest,-destaddr,-destip String: ~
  -IPPortMatchCondition,-IPPort,-port UInt16:
    required: true
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
  -LiveMigration Switch:
    required: true
  -MinBandwidthWeightAction,-MinBandwidthWeight,-minbww,-weight Byte: ~
  -NFS Switch:
    required: true
  -Name String:
    required: true
  -NetDirectPortMatchCondition,-NetDirectPort,-ndport,-networkdirectport UInt16:
    required: true
  -NetworkProfile NetworkProfile:
    values:
    - Domain
    - Public
    - Private
    - All
  -PolicyStore,-store String: ~
  -Precedence UInt32: ~
  -PriorityValue8021Action,-PriorityValue,-PriorityValue8021,-pri,-dot1p SByte: ~
  -SMB Switch:
    required: true
  -ThrottleLimit Int32: ~
  -ThrottleRateActionBitsPerSecond,-ThrottleRateAction,-ThrottleRate,-Throttle,-maxbw UInt64: ~
  -URIMatchCondition,-URI,-url String:
    required: true
  -URIRecursiveMatchCondition,-URIRecursive,-urlrecursive,-recursive Boolean: ~
  -UserMatchCondition,-User,-sid String: ~
  -WhatIf,-wi Switch: ~
  -iSCSI Switch:
    required: true
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
