description: Adds a DHCPv4 option definition on the DHCP server service
synopses:
- Add-DhcpServerv4OptionDefinition [-ComputerName <String>] [-Name] <String> [-Description
  <String>] [-OptionId] <UInt32> [-Type] <String> [-MultiValued] [-VendorClass <String>]
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
