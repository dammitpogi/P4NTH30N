description: Assigns a Provider Address to a network interface
synopses:
- New-NetVirtualizationProviderAddress -ProviderAddress <String> -InterfaceIndex <UInt32>
  -PrefixLength <Byte> [-VlanID <UInt16>] [-MACAddress <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -InterfaceIndex UInt32:
    required: true
  -MACAddress String: ~
  -PrefixLength Byte:
    required: true
  -ProviderAddress String:
    required: true
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
