description: Retrieves the contents of the DNS client cache
synopses:
- Get-DnsClientCache [[-Entry] <String[]>] [-Name <String[]>] [-Type <Type[]>] [-Status
  <Status[]>] [-Section <Section[]>] [-TimeToLive <UInt32[]>] [-DataLength <UInt16[]>]
  [-Data <String[]>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -Data String[]: ~
  -DataLength UInt16[]: ~
  -Entry String[]: ~
  -Name,-RecordName String[]: ~
  -Section Section[]:
    values:
    - Answer
    - Authority
    - Additional
  -Status Status[]:
    values:
    - Success
    - NotExist
    - NoRecords
  -ThrottleLimit Int32: ~
  -TimeToLive,-TTL UInt32[]: ~
  -Type,-RecordType Type[]:
    values:
    - A
    - NS
    - CNAME
    - SOA
    - PTR
    - MX
    - AAAA
    - SRV
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
