description: Removes policy entries for IP addresses in a virtual network
synopses:
- Remove-NetVirtualizationLookupRecord [-CustomerAddress <String[]>] [-MACAddress
  <String[]>] [-VirtualSubnetID <UInt32[]>] [-ProviderAddress <String[]>] [-CustomerID
  <String[]>] [-Context <String[]>] [-Rule <RuleType[]>] [-VMName <String[]>] [-UseVmMACAddress
  <Boolean[]>] [-Type <Type[]>] [-Unusable <Boolean[]>] [-Unsynchronized <Boolean[]>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
- Remove-NetVirtualizationLookupRecord -InputObject <CimInstance[]> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Context String[]: ~
  -CustomerAddress String[]: ~
  -CustomerID String[]: ~
  -InputObject CimInstance[]:
    required: true
  -MACAddress String[]: ~
  -PassThru Switch: ~
  -ProviderAddress String[]: ~
  -Rule RuleType[]:
    values:
    - TranslationMethodNat
    - TranslationMethodEncap
    - TranslationMethodNone
  -ThrottleLimit Int32: ~
  -Type Type[]:
    values:
    - Static
    - Dynamic
    - GatewayWildcard
    - L2Only
  -Unsynchronized Boolean[]: ~
  -Unusable Boolean[]: ~
  -UseVmMACAddress Boolean[]: ~
  -VMName String[]: ~
  -VirtualSubnetID UInt32[]: ~
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
