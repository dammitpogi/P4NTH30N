description: Modifies a DNS client Name Resolution Policy Table (NRPT) rule for the
  specified namespace
synopses:
- Set-DnsClientNrptRule [-DAEnable <Boolean>] [-DAIPsecEncryptionType <String>] [-DAIPsecRequired
  <Boolean>] [-DANameServers <String[]>] [-DAProxyServerName <String>] [-DAProxyType
  <String>] [-Comment <String>] [-DnsSecEnable <Boolean>] [-DnsSecIPsecEncryptionType
  <String>] [-DnsSecIPsecRequired <Boolean>] [-DnsSecValidationRequired <Boolean>]
  [-GpoName <String>] [-IPsecTrustAuthority <String>] [-Name] <String> [-NameEncoding
  <String>] [-NameServers <String[]>] [-Namespace <String[]>] [-Server <String>] [-DisplayName
  <String>] [-PassThru] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Comment String: ~
  -Confirm,-cf Switch: ~
  -DAEnable,-DirectAccessEnabled Boolean: ~
  -DAIPsecEncryptionType,-DirectAccessQueryIPSSECEncryption String:
    values:
    - ''
    - None
    - Low
    - Medium
    - High
  -DAIPsecRequired,-DirectAccessQueryIPsecRequired Boolean: ~
  -DANameServers,-DirectAccessDNSServers String[]: ~
  -DAProxyServerName,-DirectAccessProxyName String: ~
  -DAProxyType,-DirectAccessProxyType String:
    values:
    - ''
    - NoProxy
    - UseDefault
    - UseProxyName
  -DisplayName String: ~
  -DnsSecEnable,-DnsSecEnabled Boolean: ~
  -DnsSecIPsecEncryptionType,-DnsSecQueryIPsecEncryption String:
    values:
    - ''
    - None
    - Low
    - Medium
    - High
  -DnsSecIPsecRequired,-DnsSecQueryIPsecRequired Boolean: ~
  -DnsSecValidationRequired Boolean: ~
  -GpoName String: ~
  -IPsecTrustAuthority,-IPsecCARestriction String: ~
  -Name String:
    required: true
  -NameEncoding String:
    values:
    - Disable
    - Utf8WithMapping
    - Utf8WithoutMapping
    - Punycode
  -NameServers String[]: ~
  -Namespace String[]: ~
  -PassThru Switch: ~
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
