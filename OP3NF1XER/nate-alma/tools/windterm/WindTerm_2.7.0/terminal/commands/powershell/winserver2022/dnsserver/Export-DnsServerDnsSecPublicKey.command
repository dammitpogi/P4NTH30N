description: Exports DS and DNSKEY information for a DNSSEC-signed zone
synopses:
- Export-DnsServerDnsSecPublicKey [-ComputerName <String>] [-ZoneName] <String> [-Path
  <String>] [-PassThru] [-UnAuthenticated] [-Force] [-NoClobber] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Export-DnsServerDnsSecPublicKey [-ComputerName <String>] [-ZoneName] <String> [-Path
  <String>] [-PassThru] [-UnAuthenticated] [-Force] [-NoClobber] -DigestType <String[]>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -DigestType String[]:
    required: true
    values:
    - Sha1
    - Sha256
    - Sha384
  -Force Switch: ~
  -NoClobber Switch: ~
  -PassThru Switch: ~
  -Path String: ~
  -ThrottleLimit Int32: ~
  -UnAuthenticated Switch: ~
  -WhatIf,-wi Switch: ~
  -ZoneName,-TrustPointName,-TrustAnchorName String:
    required: true
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
