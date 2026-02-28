description: Creates a VPN Traffic selector object that configures the IKE traffic
  selector
synopses:
- New-VpnTrafficSelector [[-IPAddressRange] <String[]>] [[-PortRange] <UInt32[]>]
  [-ProtocolId <UInt32>] [-Type <Type>] [-TsPayloadId <UInt16>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -IPAddressRange String[]: ~
  -PortRange UInt32[]: ~
  -ProtocolId UInt32: ~
  -ThrottleLimit Int32: ~
  -TsPayloadId UInt16: ~
  -Type Type:
    values:
    - IPv4
    - IPv6
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
