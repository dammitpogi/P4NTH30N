description: Configures an IPAM access scope
synopses:
- Set-IpamAccessScope [-IpamRange] [-AccessScopePath <String>] [-IsInheritedAccessScope]
  -InputObject <CimInstance[]> [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAccessScope [-AccessScopePath <String>] [-IsInheritedAccessScope] -InputObject
  <CimInstance[]> [-PassThru] [-IpamDnsServer] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAccessScope [-AccessScopePath <String>] [-IsInheritedAccessScope] -InputObject
  <CimInstance[]> [-PassThru] [-IpamDhcpServer] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAccessScope [-AccessScopePath <String>] [-IsInheritedAccessScope] -InputObject
  <CimInstance[]> [-PassThru] [-IpamDhcpSuperscope] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAccessScope [-AccessScopePath <String>] [-IsInheritedAccessScope] -InputObject
  <CimInstance[]> [-PassThru] [-IpamDhcpScope] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAccessScope [-AccessScopePath <String>] [-IsInheritedAccessScope] -InputObject
  <CimInstance[]> [-PassThru] [-IpamDnsConditionalForwarder] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAccessScope [-AccessScopePath <String>] [-IsInheritedAccessScope] -InputObject
  <CimInstance[]> [-PassThru] [-IpamDnsResourceRecord] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAccessScope [-AccessScopePath <String>] [-IsInheritedAccessScope] -InputObject
  <CimInstance[]> [-PassThru] [-IpamDnsZone] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAccessScope [-AccessScopePath <String>] [-IsInheritedAccessScope] -InputObject
  <CimInstance[]> [-PassThru] [-IpamAddressSpace] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAccessScope [-AccessScopePath <String>] [-IsInheritedAccessScope] -InputObject
  <CimInstance[]> [-PassThru] [-IpamSubnet] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-IpamAccessScope [-AccessScopePath <String>] [-IsInheritedAccessScope] -InputObject
  <CimInstance[]> [-PassThru] [-IpamBlock] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AccessScopePath String: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -InputObject CimInstance[]:
    required: true
  -IpamAddressSpace Switch:
    required: true
  -IpamBlock Switch:
    required: true
  -IpamDhcpScope Switch:
    required: true
  -IpamDhcpServer Switch:
    required: true
  -IpamDhcpSuperscope Switch:
    required: true
  -IpamDnsConditionalForwarder Switch:
    required: true
  -IpamDnsResourceRecord Switch:
    required: true
  -IpamDnsServer Switch:
    required: true
  -IpamDnsZone Switch:
    required: true
  -IpamRange Switch:
    required: true
  -IpamSubnet Switch:
    required: true
  -IsInheritedAccessScope Switch: ~
  -PassThru Switch: ~
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
