description: Changes a VLAN ID or prefix length for a Provider Address
synopses:
- Set-NetVirtualizationProviderAddress [-ProviderAddress <String[]>] [-InterfaceIndex
  <UInt32[]>] [-AddressState <AddressState[]>] [-VlanID <UInt16>] [-PrefixLength <Byte>]
  [-MACAddress <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-PassThru] [<CommonParameters>]
- Set-NetVirtualizationProviderAddress -InputObject <CimInstance[]> [-VlanID <UInt16>]
  [-PrefixLength <Byte>] [-MACAddress <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [<CommonParameters>]
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
  -InputObject CimInstance[]:
    required: true
  -InterfaceIndex UInt32[]: ~
  -MACAddress String: ~
  -PassThru Switch: ~
  -PrefixLength Byte: ~
  -ProviderAddress String[]: ~
  -ThrottleLimit Int32: ~
  -VlanID UInt16: ~
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
