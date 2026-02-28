description: Deletes DHCPv6 option values set at the reservation level, scope level,
  or server level, for the standard IPv6 options or for a vendor class
synopses:
- Remove-DhcpServerv6OptionValue [-ComputerName <String>] [[-Prefix] <IPAddress>]
  [-ReservedIP <IPAddress>] [-OptionId] <UInt32[]> [-PassThru] [-VendorClass <String>]
  [-UserClass <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -OptionId UInt32[]:
    required: true
  -PassThru Switch: ~
  -Prefix IPAddress: ~
  -ReservedIP,-IPAddress IPAddress: ~
  -ThrottleLimit Int32: ~
  -UserClass String: ~
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
