description: Creates a policy entry for an IP address in a virtual network
synopses:
- New-NetVirtualizationLookupRecord -CustomerAddress <String> -VirtualSubnetID <UInt32>
  -MACAddress <String> -ProviderAddress <String> [-CustomerID <String>] [-Context
  <String>] -Rule <RuleType> [-VMName <String>] [-UseVmMACAddress <Boolean>] [-Type
  <Type>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Context String: ~
  -CustomerAddress String:
    required: true
  -CustomerID String: ~
  -MACAddress String:
    required: true
  -ProviderAddress String:
    required: true
  -Rule RuleType:
    required: true
    values:
    - TranslationMethodNat
    - TranslationMethodEncap
    - TranslationMethodNone
  -ThrottleLimit Int32: ~
  -Type Type:
    values:
    - Static
    - Dynamic
    - GatewayWildcard
    - L2Only
  -UseVmMACAddress Boolean: ~
  -VMName String: ~
  -VirtualSubnetID UInt32:
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
