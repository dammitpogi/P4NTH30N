description: Edits the port rules for a NLB cluster
synopses:
- Set-NlbClusterPortRule [-HostName <String>] [-InterfaceName <String>] [-IP <IPAddress>]
  [[-Port] <UInt32>] [-NewIP <IPAddress>] [-NewProtocol <PortRuleProtocol>] [-NewStartPort
  <Int32>] [-NewEndPort <Int32>] [-NewMode <PortRuleFilteringMode>] [-NewAffinity
  <PortRuleAffinity>] [-NewTimeout <UInt32>] [<CommonParameters>]
- Set-NlbClusterPortRule -InputObject <PortRule[]> [-NewIP <IPAddress>] [-NewProtocol
  <PortRuleProtocol>] [-NewStartPort <Int32>] [-NewEndPort <Int32>] [-NewMode <PortRuleFilteringMode>]
  [-NewAffinity <PortRuleAffinity>] [-NewTimeout <UInt32>] [<CommonParameters>]
options:
  -HostName,-Host,-HN,-H String: ~
  -IP IPAddress: ~
  -InputObject PortRule[]:
    required: true
  -InterfaceName,-Interface,-IN,-I String: ~
  -NewAffinity,-NA PortRuleAffinity:
    values:
    - None
    - Single
    - Network
  -NewEndPort,-NEP Int32: ~
  -NewIP,-NIP IPAddress: ~
  -NewMode,-NM PortRuleFilteringMode:
    values:
    - Single
    - Multiple
    - Disabled
  -NewProtocol,-NPRTCL PortRuleProtocol:
    values:
    - Tcp
    - Udp
    - Both
  -NewStartPort,-NSP Int32: ~
  -NewTimeout,-Timeout,-T UInt32: ~
  -Port,-P UInt32: ~
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
