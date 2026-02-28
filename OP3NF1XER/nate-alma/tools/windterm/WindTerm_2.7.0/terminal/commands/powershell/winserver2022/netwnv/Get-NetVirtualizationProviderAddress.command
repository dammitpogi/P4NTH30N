description: Gets Provider Addresses
synopses:
- Get-NetVirtualizationProviderAddress [-ProviderAddress <String[]>] [-InterfaceIndex
  <UInt32[]>] [-PrefixLength <Byte[]>] [-VlanID <UInt16[]>] [-AddressState <AddressState[]>]
  [-MACAddress <String[]>] [-ManagedByCluster <Boolean[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AddressState AddressState[]:
    values:
    - Invalid
    - Tentative
    - Duplicate
    - Deprecated
    - Preferred
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InterfaceIndex UInt32[]: ~
  -MACAddress String[]: ~
  -ManagedByCluster Boolean[]: ~
  -PrefixLength Byte[]: ~
  -ProviderAddress String[]: ~
  -ThrottleLimit Int32: ~
  -VlanID UInt16[]: ~
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
