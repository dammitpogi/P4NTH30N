description: Adds an address space to IPAM
synopses:
- Add-IpamAddressSpace -Name <String> [-ProviderAddressSpace] [-Owner <String>] [-Description
  <String>] [-CustomConfiguration <String>] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-IpamAddressSpace -Name <String> [-Owner <String>] [-Description <String>] [-CustomConfiguration
  <String>] [-PassThru] [-CustomerAddressSpace] -AssociatedProviderAddressSpace <String>
  [-Tenant <String>] [-VmNetwork <String>] -IsolationMethod <String> [-Force] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -AssociatedProviderAddressSpace String:
    required: true
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -CustomConfiguration String: ~
  -CustomerAddressSpace,-CA Switch:
    required: true
  -Description String: ~
  -Force Switch: ~
  -IsolationMethod String:
    required: true
  -Name String:
    required: true
  -Owner String: ~
  -PassThru Switch: ~
  -ProviderAddressSpace,-PA Switch:
    required: true
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
