description: Disables specific power management features on a network adapter
synopses:
- Disable-NetAdapterPowerManagement [-Name] <String[]> [-IncludeHidden] [-ArpOffload]
  [-D0PacketCoalescing] [-DeviceSleepOnDisconnect] [-NSOffload] [-RsnRekeyOffload]
  [-SelectiveSuspend] [-WakeOnMagicPacket] [-WakeOnPattern] [-NoRestart] [-PassThru]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Disable-NetAdapterPowerManagement -InterfaceDescription <String[]> [-IncludeHidden]
  [-ArpOffload] [-D0PacketCoalescing] [-DeviceSleepOnDisconnect] [-NSOffload] [-RsnRekeyOffload]
  [-SelectiveSuspend] [-WakeOnMagicPacket] [-WakeOnPattern] [-NoRestart] [-PassThru]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Disable-NetAdapterPowerManagement -InputObject <CimInstance[]> [-ArpOffload] [-D0PacketCoalescing]
  [-DeviceSleepOnDisconnect] [-NSOffload] [-RsnRekeyOffload] [-SelectiveSuspend] [-WakeOnMagicPacket]
  [-WakeOnPattern] [-NoRestart] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ArpOffload Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -D0PacketCoalescing Switch: ~
  -DeviceSleepOnDisconnect Switch: ~
  -IncludeHidden Switch: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceDescription,-ifDesc,-InstanceID String[]:
    required: true
  -NSOffload Switch: ~
  -Name,-ifAlias,-InterfaceAlias String[]:
    required: true
  -NoRestart Switch: ~
  -PassThru Switch: ~
  -RsnRekeyOffload Switch: ~
  -SelectiveSuspend Switch: ~
  -ThrottleLimit Int32: ~
  -WakeOnMagicPacket Switch: ~
  -WakeOnPattern Switch: ~
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
