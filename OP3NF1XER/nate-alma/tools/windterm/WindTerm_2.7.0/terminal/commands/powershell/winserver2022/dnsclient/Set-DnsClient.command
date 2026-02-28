description: Sets the interface-specific DNS client configurations on the computer
synopses:
- powershell Set-DnsClient [-InterfaceAlias] <String[]> [-ConnectionSpecificSuffix
  <String>] [-RegisterThisConnectionsAddress <Boolean>] [-UseSuffixWhenRegistering
  <Boolean>] [-ResetConnectionSpecificSuffix] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- powershell Set-DnsClient -InterfaceIndex <UInt32[]> [-ConnectionSpecificSuffix <String>]
  [-RegisterThisConnectionsAddress <Boolean>] [-UseSuffixWhenRegistering <Boolean>]
  [-ResetConnectionSpecificSuffix] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- powershell Set-DnsClient -InputObject <CimInstance[]> [-ConnectionSpecificSuffix
  <String>] [-RegisterThisConnectionsAddress <Boolean>] [-UseSuffixWhenRegistering
  <Boolean>] [-ResetConnectionSpecificSuffix] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -ConnectionSpecificSuffix,-Suffix String: ~
  -InputObject CimInstance[]:
    required: true
  -InterfaceAlias String[]:
    required: true
  -InterfaceIndex UInt32[]:
    required: true
  -PassThru Switch: ~
  -RegisterThisConnectionsAddress Boolean: ~
  -ResetConnectionSpecificSuffix,-ResetSuffix Switch: ~
  -ThrottleLimit Int32: ~
  -UseSuffixWhenRegistering Boolean: ~
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
