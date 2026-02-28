description: Performs a DNS name query resolution for the specified name
synopses:
- Resolve-DnsName [-Name] <String> [[-Type] <RecordType>] [-Server <String[]>] [-DnsOnly]
  [-CacheOnly] [-DnssecOk] [-DnssecCd] [-NoHostsFile] [-LlmnrNetbiosOnly] [-LlmnrFallback]
  [-LlmnrOnly] [-NetbiosFallback] [-NoIdn] [-NoRecursion] [-QuickTimeout] [-TcpOnly]
  [<CommonParameters>]
options:
  -CacheOnly Switch: ~
  -DnsOnly Switch: ~
  -DnssecCd Switch: ~
  -DnssecOk Switch: ~
  -LlmnrFallback Switch: ~
  -LlmnrNetbiosOnly Switch: ~
  -LlmnrOnly Switch: ~
  -Name String:
    required: true
  -NetbiosFallback Switch: ~
  -NoHostsFile Switch: ~
  -NoIdn Switch: ~
  -NoRecursion Switch: ~
  -QuickTimeout Switch: ~
  -Server String[]: ~
  -TcpOnly Switch: ~
  -Type RecordType:
    values:
    - UNKNOWN
    - A_AAAA
    - A
    - NS
    - MD
    - MF
    - CNAME
    - SOA
    - MB
    - MG
    - MR
    - 'NULL'
    - WKS
    - PTR
    - HINFO
    - MINFO
    - MX
    - TXT
    - RP
    - AFSDB
    - X25
    - ISDN
    - RT
    - AAAA
    - SRV
    - DNAME
    - OPT
    - DS
    - RRSIG
    - NSEC
    - DNSKEY
    - DHCID
    - NSEC3
    - NSEC3PARAM
    - ANY
    - ALL
    - WINS
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
