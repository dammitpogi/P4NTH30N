description: Modifies the global Name Resolution Policy Table (NRPT) settings
synopses:
- Set-DnsClientNrptGlobal [-EnableDAForAllNetworks <String>] [-GpoName <String>] [-SecureNameQueryFallback
  <String>] [-QueryPolicy <String>] [-Server <String>] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -EnableDAForAllNetworks String:
    values:
    - EnableOnNetworkID
    - EnableAlways
    - Disable
    - DisableDA
  -GpoName String: ~
  -PassThru Switch: ~
  -QueryPolicy String:
    values:
    - Disable
    - QueryIPv6Only
    - QueryBoth
  -SecureNameQueryFallback String:
    values:
    - Disable
    - FallbackSecure
    - FallbackUnsecure
    - FallbackPrivate
  -Server String: ~
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
