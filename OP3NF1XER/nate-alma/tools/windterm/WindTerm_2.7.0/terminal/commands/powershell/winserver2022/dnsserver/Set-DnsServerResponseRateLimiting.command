description: Enables RRL on a DNS server
synopses:
- Set-DnsServerResponseRateLimiting [-ResponsesPerSec <UInt32>] [-ErrorsPerSec <UInt32>]
  [-WindowInSec <UInt32>] [-IPv4PrefixLength <UInt32>] [-IPv6PrefixLength <UInt32>]
  [-LeakRate <UInt32>] [-ResetToDefault] [-TruncateRate <UInt32>] [-MaximumResponsesPerWindow
  <UInt32>] [-Mode <String>] [-ComputerName <String>] [-PassThru] [-Force] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -ErrorsPerSec UInt32: ~
  -Force Switch: ~
  -IPv4PrefixLength UInt32: ~
  -IPv6PrefixLength UInt32: ~
  -LeakRate UInt32: ~
  -MaximumResponsesPerWindow UInt32: ~
  -Mode String:
    values:
    - LogOnly
    - Enable
    - Disable
  -PassThru Switch: ~
  -ResetToDefault Switch: ~
  -ResponsesPerSec UInt32: ~
  -ThrottleLimit Int32: ~
  -TruncateRate UInt32: ~
  -WhatIf,-wi Switch: ~
  -WindowInSec UInt32: ~
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
