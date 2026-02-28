description: Gets address spaces in IPAM
synopses:
- Get-IpamAddressSpace [[-Name] <String[]>] [[-Type] <AddressSpaceType[]>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-IpamAddressSpace -MappingToProviderAddressSpace <String[]> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -MappingToProviderAddressSpace,-PA String[]:
    required: true
  -Name String[]: ~
  -ThrottleLimit Int32: ~
  -Type AddressSpaceType[]:
    values:
    - ProviderAddressSpace
    - CustomerAddressSpace
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
