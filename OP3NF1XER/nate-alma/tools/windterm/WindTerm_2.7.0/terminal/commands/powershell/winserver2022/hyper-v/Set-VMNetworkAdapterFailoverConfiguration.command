description: Configures the IP address of a virtual network adapter to be used when
  a virtual machine fails over
synopses:
- Set-VMNetworkAdapterFailoverConfiguration [-CimSession <CimSession[]>] [-ComputerName
  <String[]>] [-Credential <PSCredential[]>] [-VMName] <String> [-VMNetworkAdapterName
  <String>] [-IPv4Address <String>] [-IPv6Address <String>] [-IPv4SubnetMask <String>]
  [-IPv6SubnetPrefixLength <Int32>] [-IPv4PreferredDNSServer <String>] [-IPv4AlternateDNSServer
  <String>] [-IPv6PreferredDNSServer <String>] [-IPv6AlternateDNSServer <String>]
  [-IPv4DefaultGateway <String>] [-IPv6DefaultGateway <String>] [-ClearFailoverIPv4Settings]
  [-ClearFailoverIPv6Settings] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterFailoverConfiguration [-VMNetworkAdapter] <VMNetworkAdapter>
  [-IPv4Address <String>] [-IPv6Address <String>] [-IPv4SubnetMask <String>] [-IPv6SubnetPrefixLength
  <Int32>] [-IPv4PreferredDNSServer <String>] [-IPv4AlternateDNSServer <String>] [-IPv6PreferredDNSServer
  <String>] [-IPv6AlternateDNSServer <String>] [-IPv4DefaultGateway <String>] [-IPv6DefaultGateway
  <String>] [-ClearFailoverIPv4Settings] [-ClearFailoverIPv6Settings] [-Passthru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-VMNetworkAdapterFailoverConfiguration [-VM] <VirtualMachine> [-VMNetworkAdapterName
  <String>] [-IPv4Address <String>] [-IPv6Address <String>] [-IPv4SubnetMask <String>]
  [-IPv6SubnetPrefixLength <Int32>] [-IPv4PreferredDNSServer <String>] [-IPv4AlternateDNSServer
  <String>] [-IPv6PreferredDNSServer <String>] [-IPv6AlternateDNSServer <String>]
  [-IPv4DefaultGateway <String>] [-IPv6DefaultGateway <String>] [-ClearFailoverIPv4Settings]
  [-ClearFailoverIPv6Settings] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CimSession CimSession[]: ~
  -ClearFailoverIPv4Settings Switch: ~
  -ClearFailoverIPv6Settings Switch: ~
  -ComputerName String[]: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential[]: ~
  -IPv4Address String: ~
  -IPv4AlternateDNSServer String: ~
  -IPv4DefaultGateway String: ~
  -IPv4PreferredDNSServer String: ~
  -IPv4SubnetMask String: ~
  -IPv6Address String: ~
  -IPv6AlternateDNSServer String: ~
  -IPv6DefaultGateway String: ~
  -IPv6PreferredDNSServer String: ~
  -IPv6SubnetPrefixLength Int32: ~
  -Passthru Switch: ~
  -VM VirtualMachine:
    required: true
  -VMName String:
    required: true
  -VMNetworkAdapter VMNetworkAdapter:
    required: true
  -VMNetworkAdapterName String: ~
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
