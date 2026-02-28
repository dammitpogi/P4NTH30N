description: Adds a DHCPv6 option definition to a DHCP server service
synopses:
- Add-DhcpServerv6OptionDefinition [-ComputerName <String>] [-OptionId] <UInt32> [-Type]
  <String> [-Name] <String> [-MultiValued] [-Description <String>] [-VendorClass <String>]
  [-DefaultValue <String[]>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DefaultValue String[]: ~
  -Description String: ~
  -MultiValued Switch: ~
  -Name String:
    required: true
  -OptionId UInt32:
    required: true
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -Type String:
    required: true
    values:
    - Byte
    - Word
    - DWord
    - DWordDWord
    - IPv4Address
    - String
    - BinaryData
    - EncapsulatedData
    - IPv6Address
  -VendorClass String: ~
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
