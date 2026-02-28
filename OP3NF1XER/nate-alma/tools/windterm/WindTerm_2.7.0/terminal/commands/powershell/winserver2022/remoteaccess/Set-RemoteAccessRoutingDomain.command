description: Configures S2S VPN settings for a routing domain configuration
synopses:
- Set-RemoteAccessRoutingDomain [-Name] <String> [-InterimAccountingPeriodSec <UInt32>]
  [-IPAddressRange <String[]>] [-IPv6Prefix <String>] [-NetBiosIPAddress <IPAddress[]>]
  [-MaximumVpnConnections <UInt32>] [-TenantName <String[]>] [-PassThru] [-Force]
  [-EnableQoS <EnableQoS>] [-TxBandwidthKbps <UInt64>] [-RxBandwidthKbps <UInt64>]
  [-DnsIPAddress <IPAddress[]>] [-EncryptionType <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Set-RemoteAccessRoutingDomain [-Name] <String> [-IdleDisconnectSec <UInt32>] [-InterimAccountingPeriodSec
  <UInt32>] [-IPAddressRange <String[]>] [-IPv6Prefix <String>] [-SaLifeTimeSec <UInt32>]
  [-MMSaLifeTimeSec <UInt32>] [-NetBiosIPAddress <IPAddress[]>] [-MaximumVpnConnections
  <UInt32>] [-TenantName <String[]>] [-PassThru] [-Force] [-EnableQoS <EnableQoS>]
  [-TxBandwidthKbps <UInt64>] [-RxBandwidthKbps <UInt64>] [-DnsIPAddress <IPAddress[]>]
  [-CustomPolicy] [-AuthenticationTransformConstant <AuthenticationTransformConstant>]
  [-CipherTransformConstant <CipherTransformConstant>] [-EncryptionMethod <EncryptionMethod>]
  [-IntegrityCheckMethod <IntegrityCheckMethod>] [-PfsGroup <PfsGroup>] [-SaRenegotiationDataSizeKB
  <UInt32>] [-DHGroup <DHGroup>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AuthenticationTransformConstant AuthenticationTransformConstant:
    values:
    - MD596
    - SHA196
    - SHA256128
    - GCMAES128
    - GCMAES192
    - GCMAES256
    - None
  -CimSession,-Session CimSession[]: ~
  -CipherTransformConstant CipherTransformConstant:
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
  -DnsIPAddress IPAddress[]: ~
  -EnableQoS EnableQoS:
    values:
    - Disabled
    - Enabled
  -EncryptionMethod EncryptionMethod:
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
  -Force Switch: ~
  -IPAddressRange String[]: ~
  -IPv6Prefix String: ~
  -IdleDisconnectSec UInt32: ~
  -IntegrityCheckMethod IntegrityCheckMethod:
    values:
    - MD5
    - SHA1
    - SHA256
    - SHA384
  -InterimAccountingPeriodSec UInt32: ~
  -MMSaLifeTimeSec UInt32: ~
  -MaximumVpnConnections UInt32: ~
  -Name,-RoutingDomainName,-RoutingDomain String:
    required: true
  -NetBiosIPAddress IPAddress[]: ~
  -PassThru Switch: ~
  -PfsGroup PfsGroup:
    values:
    - None
    - PFS1
    - PFS2
    - PFS2048
    - ECP256
    - ECP384
    - PFSMM
    - PFS24
  -RxBandwidthKbps UInt64: ~
  -SaLifeTimeSec,-QMSaLifeTimeSec UInt32: ~
  -SaRenegotiationDataSizeKB UInt32: ~
  -TenantName String[]: ~
  -ThrottleLimit Int32: ~
  -TxBandwidthKbps UInt64: ~
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
