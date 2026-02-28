description: Gets DNS resource records from IPAM database
synopses:
- Get-IpamDnsResourceRecord [-ZoneName] <String[]> [[-RecordName] <String[]>] [[-RecordType]
  <DnsResourceRecordType[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -RecordName String[]: ~
  -RecordType DnsResourceRecordType[]:
    values:
    - A
    - AAAA
    - PTR
    - SOA
    - NS
    - CNAME
    - DNAME
    - MX
    - SRV
    - TXT
    - AFSDB
    - ATMA
    - DHCID
    - HINFO
    - ISDN
    - RP
    - RT
    - WINS
    - WINSR
    - WKS
    - X25
  -ThrottleLimit Int32: ~
  -ZoneName String[]:
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
