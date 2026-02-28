description: Modifies one or more configuration parameters of the database of the
  DHCP server service
synopses:
- Set-DhcpServerDatabase [[-FileName] <String>] [[-BackupPath] <String>] [-BackupInterval
  <UInt32>] [-CleanupInterval <UInt32>] [-RestoreFromBackup <Boolean>] [-ComputerName
  <String>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -BackupInterval UInt32: ~
  -BackupPath String: ~
  -CimSession,-Session CimSession[]: ~
  -CleanupInterval UInt32: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -FileName String: ~
  -PassThru Switch: ~
  -RestoreFromBackup Boolean: ~
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
