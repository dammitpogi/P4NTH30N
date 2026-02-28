description: Installs a printer port on the specified computer
synopses:
- Add-PrinterPort [-Name] <String> [-ComputerName <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-PrinterPort [-Name] <String> [-ComputerName <String>] [-SNMP <UInt32>] [-SNMPCommunity
  <String>] [-LprHostAddress] <String> [-LprQueueName] <String> [-LprByteCounting]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-PrinterPort [-Name] <String> [-ComputerName <String>] [-PrinterHostAddress]
  <String> [-PortNumber <UInt32>] [-SNMP <UInt32>] [-SNMPCommunity <String>] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-PrinterPort [-ComputerName <String>] [-HostName] <String> [-PrinterName] <String>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-CN String: ~
  -Confirm,-cf Switch: ~
  -HostName String:
    required: true
  -LprByteCounting Switch: ~
  -LprHostAddress String:
    required: true
  -LprQueueName String:
    required: true
  -Name String:
    required: true
  -PortNumber UInt32: ~
  -PrinterHostAddress String:
    required: true
  -PrinterName String:
    required: true
  -SNMP,-SNMPIndex UInt32: ~
  -SNMPCommunity String: ~
  -ThrottleLimit Int32: ~
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
