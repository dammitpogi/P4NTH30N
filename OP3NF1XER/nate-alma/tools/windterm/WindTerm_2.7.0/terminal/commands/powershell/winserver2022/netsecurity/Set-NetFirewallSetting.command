description: Modifies the global firewall settings of the target computer
synopses:
- Set-NetFirewallSetting [-PolicyStore <String>] [-GPOSession <String>] [-Exemptions
  <TrafficExemption>] [-EnableStatefulFtp <GpoBoolean>] [-EnableStatefulPptp <GpoBoolean>]
  [-RemoteMachineTransportAuthorizationList <String>] [-RemoteMachineTunnelAuthorizationList
  <String>] [-RemoteUserTransportAuthorizationList <String>] [-RemoteUserTunnelAuthorizationList
  <String>] [-RequireFullAuthSupport <GpoBoolean>] [-CertValidationLevel <CRLCheck>]
  [-AllowIPsecThroughNAT <IPsecThroughNAT>] [-MaxSAIdleTimeSeconds <UInt32>] [-KeyEncoding
  <KeyEncoding>] [-EnablePacketQueuing <PacketQueuing>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetFirewallSetting -InputObject <CimInstance[]> [-Exemptions <TrafficExemption>]
  [-EnableStatefulFtp <GpoBoolean>] [-EnableStatefulPptp <GpoBoolean>] [-RemoteMachineTransportAuthorizationList
  <String>] [-RemoteMachineTunnelAuthorizationList <String>] [-RemoteUserTransportAuthorizationList
  <String>] [-RemoteUserTunnelAuthorizationList <String>] [-RequireFullAuthSupport
  <GpoBoolean>] [-CertValidationLevel <CRLCheck>] [-AllowIPsecThroughNAT <IPsecThroughNAT>]
  [-MaxSAIdleTimeSeconds <UInt32>] [-KeyEncoding <KeyEncoding>] [-EnablePacketQueuing
  <PacketQueuing>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AllowIPsecThroughNAT IPsecThroughNAT:
    values:
    - None
    - Server
    - Both
    - NotConfigured
  -AsJob Switch: ~
  -CertValidationLevel CRLCheck:
    values:
    - None
    - AttemptCrlCheck
    - RequireCrlCheck
    - NotConfigured
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EnablePacketQueuing PacketQueuing:
    values:
    - None
    - Inbound
    - Forward
    - NotConfigured
  -EnableStatefulFtp GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -EnableStatefulPptp GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -Exemptions TrafficExemption:
    values:
    - None
    - NeighborDiscovery
    - Icmp
    - RouterDiscovery
    - Dhcp
    - NotConfigured
  -GPOSession String: ~
  -InputObject CimInstance[]:
    required: true
  -KeyEncoding KeyEncoding:
    values:
    - UTF16
    - UTF8
    - NotConfigured
  -MaxSAIdleTimeSeconds UInt32: ~
  -PassThru Switch: ~
  -PolicyStore String: ~
  -RemoteMachineTransportAuthorizationList String: ~
  -RemoteMachineTunnelAuthorizationList String: ~
  -RemoteUserTransportAuthorizationList String: ~
  -RemoteUserTunnelAuthorizationList String: ~
  -RequireFullAuthSupport GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
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
