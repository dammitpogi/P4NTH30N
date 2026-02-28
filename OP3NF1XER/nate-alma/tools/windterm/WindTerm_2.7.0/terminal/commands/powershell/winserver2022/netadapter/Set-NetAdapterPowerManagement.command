description: Sets the power management properties on the network adapter
synopses:
- Set-NetAdapterPowerManagement [-Name] <String[]> [-IncludeHidden] [-ArpOffload <Setting>]
  [-D0PacketCoalescing <Setting>] [-DeviceSleepOnDisconnect <Setting>] [-NSOffload
  <Setting>] [-RsnRekeyOffload <Setting>] [-SelectiveSuspend <Setting>] [-WakeOnMagicPacket
  <Setting>] [-WakeOnPattern <Setting>] [-NoRestart] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetAdapterPowerManagement -InterfaceDescription <String[]> [-IncludeHidden]
  [-ArpOffload <Setting>] [-D0PacketCoalescing <Setting>] [-DeviceSleepOnDisconnect
  <Setting>] [-NSOffload <Setting>] [-RsnRekeyOffload <Setting>] [-SelectiveSuspend
  <Setting>] [-WakeOnMagicPacket <Setting>] [-WakeOnPattern <Setting>] [-NoRestart]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-NetAdapterPowerManagement -InputObject <CimInstance[]> [-ArpOffload <Setting>]
  [-D0PacketCoalescing <Setting>] [-DeviceSleepOnDisconnect <Setting>] [-NSOffload
  <Setting>] [-RsnRekeyOffload <Setting>] [-SelectiveSuspend <Setting>] [-WakeOnMagicPacket
  <Setting>] [-WakeOnPattern <Setting>] [-NoRestart] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ArpOffload Setting:
    values:
    - Enabled
    - Disabled
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -D0PacketCoalescing Setting:
    values:
    - Enabled
    - Disabled
  -DeviceSleepOnDisconnect Setting:
    values:
    - Enabled
    - Disabled
  -IncludeHidden Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -NSOffload Setting:
    values:
    - Enabled
    - Disabled
  -Name,-ifAlias,-InterfaceAlias String[]:
    required: true
  -NoRestart Switch: ~
  -PassThru Switch: ~
  -RsnRekeyOffload Setting:
    values:
    - Enabled
    - Disabled
  -SelectiveSuspend Setting:
    values:
    - Enabled
    - Disabled
  -ThrottleLimit Int32: ~
  -WakeOnMagicPacket Setting:
    values:
    - Enabled
    - Disabled
  -WakeOnPattern Setting:
    values:
    - Enabled
    - Disabled
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
