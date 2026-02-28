description: Modifies address spaces in IPAM
synopses:
- Set-IpamAddressSpace [-Name] <String[]> [-NewName <String>] [-Owner <String>] [-Description
  <String>] [-AddCustomConfiguration <String>] [-RemoveCustomConfiguration <String>]
  [-AssociatedProviderAddressSpace <String>] [-Tenant <String>] [-VmNetwork <String>]
  [-IsolationMethod <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAddressSpace -InputObject <CimInstance[]> [-NewName <String>] [-Owner <String>]
  [-Description <String>] [-AddCustomConfiguration <String>] [-RemoveCustomConfiguration
  <String>] [-AssociatedProviderAddressSpace <String>] [-Tenant <String>] [-VmNetwork
  <String>] [-IsolationMethod <String>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddCustomConfiguration String: ~
  -AsJob Switch: ~
  -AssociatedProviderAddressSpace,-PA String: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -InputObject CimInstance[]:
    required: true
  -IsolationMethod String: ~
  -Name String[]:
    required: true
  -NewName String: ~
  -Owner String: ~
  -PassThru Switch: ~
  -RemoveCustomConfiguration String: ~
  -Tenant String: ~
  -ThrottleLimit Int32: ~
  -VmNetwork String: ~
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
