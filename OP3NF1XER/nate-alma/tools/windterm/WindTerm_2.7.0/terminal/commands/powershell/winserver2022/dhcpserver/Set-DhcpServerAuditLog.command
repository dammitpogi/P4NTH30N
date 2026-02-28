description: Sets the DHCP server service audit log configuration on the DHCP server
  service that runs on the computer
synopses:
- Set-DhcpServerAuditLog [[-Enable] <Boolean>] [[-Path] <String>] [-MaxMBFileSize
  <UInt32>] [-DiskCheckInterval <UInt32>] [-MinMBDiskSpace <UInt32>] [-ComputerName
  <String>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DiskCheckInterval UInt32: ~
  -Enable Boolean: ~
  -MaxMBFileSize UInt32: ~
  -MinMBDiskSpace UInt32: ~
  -PassThru Switch: ~
  -Path String: ~
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
