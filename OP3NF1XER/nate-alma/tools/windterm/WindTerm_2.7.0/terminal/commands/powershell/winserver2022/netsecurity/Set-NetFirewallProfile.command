description: Configures settings that apply to the per-profile configurations of the
  Windows Firewall with Advanced Security
synopses:
- Set-NetFirewallProfile [-Name] <String[]> [-PolicyStore <String>] [-GPOSession <String>]
  [-Enabled <GpoBoolean>] [-DefaultInboundAction <Action>] [-DefaultOutboundAction
  <Action>] [-AllowInboundRules <GpoBoolean>] [-AllowLocalFirewallRules <GpoBoolean>]
  [-AllowLocalIPsecRules <GpoBoolean>] [-AllowUserApps <GpoBoolean>] [-AllowUserPorts
  <GpoBoolean>] [-AllowUnicastResponseToMulticast <GpoBoolean>] [-NotifyOnListen <GpoBoolean>]
  [-EnableStealthModeForIPsec <GpoBoolean>] [-LogFileName <String>] [-LogMaxSizeKilobytes
  <UInt64>] [-LogAllowed <GpoBoolean>] [-LogBlocked <GpoBoolean>] [-LogIgnored <GpoBoolean>]
  [-DisabledInterfaceAliases <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetFirewallProfile [-All] [-PolicyStore <String>] [-GPOSession <String>] [-Enabled
  <GpoBoolean>] [-DefaultInboundAction <Action>] [-DefaultOutboundAction <Action>]
  [-AllowInboundRules <GpoBoolean>] [-AllowLocalFirewallRules <GpoBoolean>] [-AllowLocalIPsecRules
  <GpoBoolean>] [-AllowUserApps <GpoBoolean>] [-AllowUserPorts <GpoBoolean>] [-AllowUnicastResponseToMulticast
  <GpoBoolean>] [-NotifyOnListen <GpoBoolean>] [-EnableStealthModeForIPsec <GpoBoolean>]
  [-LogFileName <String>] [-LogMaxSizeKilobytes <UInt64>] [-LogAllowed <GpoBoolean>]
  [-LogBlocked <GpoBoolean>] [-LogIgnored <GpoBoolean>] [-DisabledInterfaceAliases
  <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Set-NetFirewallProfile -InputObject <CimInstance[]> [-Enabled <GpoBoolean>] [-DefaultInboundAction
  <Action>] [-DefaultOutboundAction <Action>] [-AllowInboundRules <GpoBoolean>] [-AllowLocalFirewallRules
  <GpoBoolean>] [-AllowLocalIPsecRules <GpoBoolean>] [-AllowUserApps <GpoBoolean>]
  [-AllowUserPorts <GpoBoolean>] [-AllowUnicastResponseToMulticast <GpoBoolean>] [-NotifyOnListen
  <GpoBoolean>] [-EnableStealthModeForIPsec <GpoBoolean>] [-LogFileName <String>]
  [-LogMaxSizeKilobytes <UInt64>] [-LogAllowed <GpoBoolean>] [-LogBlocked <GpoBoolean>]
  [-LogIgnored <GpoBoolean>] [-DisabledInterfaceAliases <String[]>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -All Switch: ~
  -AllowInboundRules GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -AllowLocalFirewallRules GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -AllowLocalIPsecRules GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -AllowUnicastResponseToMulticast GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -AllowUserApps GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -AllowUserPorts GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -DefaultInboundAction Action:
    values:
    - NotConfigured
    - Allow
    - Block
  -DefaultOutboundAction Action:
    values:
    - NotConfigured
    - Allow
    - Block
  -DisabledInterfaceAliases String[]: ~
  -EnableStealthModeForIPsec GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -Enabled GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -GPOSession String: ~
  -InputObject CimInstance[]:
    required: true
  -LogAllowed GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -LogBlocked GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -LogFileName String: ~
  -LogIgnored GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -LogMaxSizeKilobytes UInt64: ~
  -Name,-Profile String[]:
    required: true
  -NotifyOnListen GpoBoolean:
    values:
    - 'False'
    - 'True'
    - NotConfigured
  -PassThru Switch: ~
  -PolicyStore String: ~
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
