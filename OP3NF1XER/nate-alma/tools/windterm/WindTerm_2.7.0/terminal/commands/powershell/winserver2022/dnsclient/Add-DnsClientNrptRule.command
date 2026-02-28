description: Adds a rule to the NRPT
synopses:
- Add-DnsClientNrptRule [-GpoName <String>] [-DANameServers <String[]>] [-DAIPsecRequired]
  [-DAIPsecEncryptionType <String>] [-DAProxyServerName <String>] [-DnsSecEnable]
  [-DnsSecIPsecRequired] [-DnsSecIPsecEncryptionType <String>] [-NameServers <String[]>]
  [-NameEncoding <String>] [-Namespace] <String[]> [-Server <String>] [-DAProxyType
  <String>] [-DnsSecValidationRequired] [-DAEnable] [-IPsecTrustAuthority <String>]
  [-Comment <String>] [-DisplayName <String>] [-PassThru] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Comment String: ~
  -Confirm,-cf Switch: ~
  -DAEnable,-DirectAccessEnabled Switch: ~
  -DAIPsecEncryptionType,-DirectAccessQueryIPSSECEncryption String:
    values:
    - ''
    - None
    - Low
    - Medium
    - High
  -DAIPsecRequired,-DirectAccessQueryIPsecRequired Switch: ~
  -DANameServers,-DirectAccessDnsServers String[]: ~
  -DAProxyServerName,-DirectAccessProxyName String: ~
  -DAProxyType,-DirectAccessProxyType String:
    values:
    - ''
    - NoProxy
    - UseDefault
    - UseProxyName
  -DisplayName String: ~
  -DnsSecEnable,-DnsSecEnabled Switch: ~
  -DnsSecIPsecEncryptionType,-DnsSecQueryIPsecEncryption String:
    values:
    - ''
    - None
    - Low
    - Medium
    - High
  -DnsSecIPsecRequired,-DnsSecQueryIPsecRequired Switch: ~
  -DnsSecValidationRequired Switch: ~
  -GpoName String: ~
  -IPsecTrustAuthority,-IPsecCARestriction String: ~
  -NameEncoding String:
    values:
    - Disable
    - Utf8WithMapping
    - Utf8WithoutMapping
    - Punycode
  -NameServers String[]: ~
  -Namespace String[]:
    required: true
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
