description: Specifies the policy store from which the cmdlet should pull configuration
  information
synopses:
- Set-NCSIPolicyConfiguration [-PolicyStore <String>] [-GPOSession <String>] [[-CorporateDNSProbeHostAddress]
  <String>] [[-CorporateDNSProbeHostName] <String>] [[-CorporateSitePrefixList] <String[]>]
  [[-CorporateWebsiteProbeURL] <String>] [[-DomainLocationDeterminationURL] <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Set-NCSIPolicyConfiguration -InputObject <CimInstance[]> [[-CorporateDNSProbeHostAddress]
  <String>] [[-CorporateDNSProbeHostName] <String>] [[-CorporateSitePrefixList] <String[]>]
  [[-CorporateWebsiteProbeURL] <String>] [[-DomainLocationDeterminationURL] <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Confirm,-cf Switch: ~
  -CorporateDNSProbeHostAddress String: ~
  -CorporateDNSProbeHostName String: ~
  -CorporateSitePrefixList String[]: ~
  -CorporateWebsiteProbeURL String: ~
  -DomainLocationDeterminationURL String: ~
  -GPOSession String: ~
  -InputObject CimInstance[]:
    required: true
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
