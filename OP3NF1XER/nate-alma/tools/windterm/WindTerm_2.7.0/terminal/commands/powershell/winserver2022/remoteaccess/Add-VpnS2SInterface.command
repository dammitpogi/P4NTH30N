description: Create a S2S interface with the specified parameters
synopses:
- Add-VpnS2SInterface [-Name] <String> [-Protocol <String>] [-Destination] <String[]>
  [-AdminStatus <Boolean>] [-PromoteAlternate <Boolean>] [-AuthenticationMethod <String>]
  [-PostConnectionIPv4Subnet <String[]>] [-PostConnectionIPv6Subnet <String[]>] [-InitiateConfigPayload
  <Boolean>] [-RadiusAttributeClass <String>] [-EnableQoS <EnableQoS>] [-TxBandwidthKbps
  <UInt64>] [-RxBandwidthKbps <UInt64>] [-IPv4TriggerFilter <String[]>] [-IPv6TriggerFilter
  <String[]>] [-Persistent] [-AutoConnectEnabled <Boolean>] [-IPv4TriggerFilterAction
  <Action>] [-IPv6TriggerFilterAction <Action>] [-SADataSizeForRenegotiationKilobytes
  <UInt32>] [-IPv4Subnet <String[]>] [-IPv6Subnet <String[]>] [-ResponderAuthenticationMethod
  <String>] [-PassThru] [[-RoutingDomain] <String>] [-Certificate <X509Certificate2>]
  [-SharedSecret <String>] [-NetworkOutageTimeSeconds <UInt32>] [-NumberOfTries <UInt32>]
  [-RetryIntervalSeconds <UInt32>] [-SALifeTimeSeconds <UInt32>] [-MMSALifeTimeSeconds
  <UInt32>] [-EapMethod <String>] [-InternalIPv4 <Boolean>] [-InternalIPv6 <Boolean>]
  [-IdleDisconnectSeconds <UInt32>] [-UserName <String>] [-Password <String>] [-SourceIpAddress
  <String>] [-LocalVpnTrafficSelector <CimInstance[]>] [-RemoteVpnTrafficSelector
  <CimInstance[]>] [-EncryptionType <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-VpnS2SInterface [-Name] <String> [-Destination] <String[]> [-AdminStatus <Boolean>]
  [-EnableQoS <EnableQoS>] [-TxBandwidthKbps <UInt64>] [-RxBandwidthKbps <UInt64>]
  [-IPv4Subnet <String[]>] [-IPv6Subnet <String[]>] [-PassThru] [[-RoutingDomain]
  <String>] [-InternalIPv4 <Boolean>] [-InternalIPv6 <Boolean>] -SourceIpAddress <String>
  [[-GreKey] <UInt32>] [-GreTunnel] [-IPv4Address <String>] [-IPv6Address <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-VpnS2SInterface [-Name] <String> [-Protocol <String>] [-Destination] <String[]>
  [-AdminStatus <Boolean>] [-PromoteAlternate <Boolean>] [-AuthenticationMethod <String>]
  [-PostConnectionIPv4Subnet <String[]>] [-PostConnectionIPv6Subnet <String[]>] [-InitiateConfigPayload
  <Boolean>] [-RadiusAttributeClass <String>] [-EnableQoS <EnableQoS>] [-TxBandwidthKbps
  <UInt64>] [-RxBandwidthKbps <UInt64>] [-IPv4TriggerFilter <String[]>] [-IPv6TriggerFilter
  <String[]>] [-Persistent] [-AutoConnectEnabled <Boolean>] [-IPv4TriggerFilterAction
  <Action>] [-IPv6TriggerFilterAction <Action>] [-SADataSizeForRenegotiationKilobytes
  <UInt32>] [-IPv4Subnet <String[]>] [-IPv6Subnet <String[]>] [-ResponderAuthenticationMethod
  <String>] [-PassThru] [[-RoutingDomain] <String>] [-Certificate <X509Certificate2>]
  [-SharedSecret <String>] [-NetworkOutageTimeSeconds <UInt32>] [-NumberOfTries <UInt32>]
  [-RetryIntervalSeconds <UInt32>] [-SALifeTimeSeconds <UInt32>] [-MMSALifeTimeSeconds
  <UInt32>] [-EapMethod <String>] [-InternalIPv4 <Boolean>] [-InternalIPv6 <Boolean>]
  [-IdleDisconnectSeconds <UInt32>] [-UserName <String>] [-Password <String>] [-CustomPolicy]
  [-EncryptionMethod <EncryptionMethod>] [-IntegrityCheckMethod <IntegrityCheckMethod>]
  [-CipherTransformConstants <CipherTransformConstants>] [-AuthenticationTransformConstants
  <AuthenticationTransformConstants>] [-PfsGroup <PfsGroup>] [-DHGroup <DHGroup>]
  [-SourceIpAddress <String>] [-LocalVpnTrafficSelector <CimInstance[]>] [-RemoteVpnTrafficSelector
  <CimInstance[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AdminStatus Boolean: ~
  -AsJob Switch: ~
  -AuthenticationMethod String:
    values:
    - EAP
    - MachineCertificates
    - PSKOnly
    - MSCHAPv2
    - ''
  -AuthenticationTransformConstants,-FirstTransformType,-AuthenticationTransformConstant AuthenticationTransformConstants:
    values:
    - MD596
    - SHA196
    - SHA256128
    - GCMAES128
    - GCMAES192
    - GCMAES256
    - None
  -AutoConnectEnabled Boolean: ~
  -Certificate,-Cert X509Certificate2: ~
  -CimSession,-Session CimSession[]: ~
  -CipherTransformConstants,-OtherCipherAlgorithm,-FirstCipherAlgorithm,-CipherTransformConstant CipherTransformConstants:
    values:
    - DES
    - DES3
    - AES128
    - AES192
    - AES256
    - GCMAES128
    - GCMAES192
    - GCMAES256
    - None
  -Confirm,-cf Switch: ~
  -CustomPolicy Switch:
    required: true
  -DHGroup DHGroup:
    values:
    - None
    - Group1
    - Group2
    - Group14
    - ECP256
    - ECP384
    - Group24
  -Destination,-RemoteTunnelEndpoint,-RemoteTunnelHostname,-RemoteAddress String[]:
    required: true
  -EapMethod String:
    values:
    - EAP-TLS
    - EAP-PEAP
    - EAP-MSCHAPv2
    - ''
  -EnableQoS EnableQoS:
    values:
    - Disabled
    - Enabled
  -EncryptionMethod,-Encryption EncryptionMethod:
    values:
    - DES
    - DES3
    - AES128
    - AES192
    - AES256
  -EncryptionType String:
    values:
    - NoEncryption
    - RequireEncryption
    - OptionalEncryption
    - MaximumEncryption
  -GreKey UInt32: ~
  -GreTunnel Switch:
    required: true
  -IPv4Address String: ~
  -IPv4Subnet,-IPv4TriggerSubnet String[]: ~
  -IPv4TriggerFilter String[]: ~
  -IPv4TriggerFilterAction Action:
    values:
    - Allow
    - Deny
  -IPv6Address String: ~
  -IPv6Subnet,-IPv6TriggerSubnet String[]: ~
  -IPv6TriggerFilter String[]: ~
  -IPv6TriggerFilterAction Action:
    values:
    - Allow
    - Deny
  -IdleDisconnectSeconds,-IdleDurationSeconds,-IdleDisconnectSec UInt32: ~
  -InitiateConfigPayload Boolean: ~
  -IntegrityCheckMethod,-OtherHashAlgorithm,-FirstIntegrityAlgorithm IntegrityCheckMethod:
    values:
    - MD5
    - SHA1
    - SHA256
    - SHA384
  -InternalIPv4 Boolean: ~
  -InternalIPv6 Boolean: ~
  -LocalVpnTrafficSelector CimInstance[]: ~
  -MMSALifeTimeSeconds,-MMSaLifeTimeSec UInt32: ~
  -Name,-ElementName String:
    required: true
  -NetworkOutageTimeSeconds,-NetworkOutageTimeSec UInt32:
    values:
    - '3'
    - '6'
    - '9'
    - '12'
    - '15'
    - '30'
    - '60'
    - '120'
    - '240'
    - '360'
    - '720'
    - '900'
  -NumberOfTries UInt32: ~
  -PassThru Switch: ~
  -Password String: ~
  -Persistent Switch: ~
  -PfsGroup,-PfsGroupId PfsGroup:
    values:
    - None
    - PFS1
    - PFS2
    - PFS2048
    - ECP256
    - ECP384
    - PFSMM
    - PFS24
  -PostConnectionIPv4Subnet String[]: ~
  -PostConnectionIPv6Subnet String[]: ~
  -PromoteAlternate Boolean: ~
  -Protocol,-KeyModule String:
    values:
    - L2TP
    - IKEv2
    - Automatic
    - SSTP
  -RadiusAttributeClass String: ~
  -RemoteVpnTrafficSelector CimInstance[]: ~
  -ResponderAuthenticationMethod String:
    values:
    - MachineCertificates
    - PSKOnly
    - ''
  -RetryIntervalSeconds,-RetryIntervalSec UInt32: ~
  -RoutingDomain,-RoutingDomainName String: ~
  -RxBandwidthKbps UInt64: ~
  -SADataSizeForRenegotiationKilobytes,-SaRenegotiationDataSizeKB,-LifeTimeKiloBytes UInt32: ~
  -SALifeTimeSeconds,-SaLifeTimeSec,-LifeTimeSeconds,-QMSALifeTimeSeconds UInt32: ~
  -SharedSecret String: ~
  -SourceIpAddress String: ~
  -ThrottleLimit Int32: ~
  -TxBandwidthKbps UInt64: ~
  -UserName,-User String: ~
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
