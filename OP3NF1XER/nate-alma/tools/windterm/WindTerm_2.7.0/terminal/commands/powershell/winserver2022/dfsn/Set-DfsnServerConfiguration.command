description: Changes settings for a DFS namespace root server
synopses:
- Set-DfsnServerConfiguration [-ComputerName] <String> [[-SyncIntervalSec] <UInt32>]
  [[-EnableSiteCostedReferrals] <Boolean>] [[-EnableInsiteReferrals] <Boolean>] [[-LdapTimeoutSec]
  <UInt32>] [[-PreferLogonDC] <Boolean>] [[-UseFqdn] <Boolean>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Server,-name,-NamespaceServer String:
    required: true
  -Confirm,-cf Switch: ~
  -EnableInsiteReferrals,-insite Boolean: ~
  -EnableSiteCostedReferrals,-Sitecosted,-SiteCostedReferrals Boolean: ~
  -LdapTimeoutSec,-LdapTimeout UInt32: ~
  -PreferLogonDC Boolean: ~
  -SyncIntervalSec,-SyncInterval UInt32: ~
  -ThrottleLimit Int32: ~
  -UseFqdn,-Fqdn,-dfsdnsconfig,-UseFullyQualifiedDomainNames Boolean: ~
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
