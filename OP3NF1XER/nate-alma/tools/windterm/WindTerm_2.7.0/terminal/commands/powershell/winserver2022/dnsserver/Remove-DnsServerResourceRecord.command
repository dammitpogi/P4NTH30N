description: Removes specified DNS server resource records from a zone
synopses:
- Remove-DnsServerResourceRecord [-ZoneName] <String> [-PassThru] [-ComputerName <String>]
  [-Force] [-ZoneScope <String>] [-VirtualizationInstance <String>] -InputObject <CimInstance>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Remove-DnsServerResourceRecord [-ZoneName] <String> [-PassThru] [-ComputerName <String>]
  [-Force] [-ZoneScope <String>] [-VirtualizationInstance <String>] [-RecordData <String[]>]
  [-Name] <String> [-Type] <UInt16> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-DnsServerResourceRecord [-ZoneName] <String> [-PassThru] [-ComputerName <String>]
  [-Force] [-ZoneScope <String>] [-VirtualizationInstance <String>] [-RRType] <String>
  [-RecordData <String[]>] [-Name] <String> [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn,-ForwardLookupPrimaryServer String: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -InputObject CimInstance:
    required: true
  -Name,-RecordName String:
    required: true
  -PassThru Switch: ~
  -RRType String:
    required: true
    values:
    - HInfo
    - Afsdb
    - Atma
    - Isdn
    - Key
    - Mb
    - Md
    - Mf
    - Mg
    - MInfo
    - Mr
    - Mx
    - NsNxt
    - Rp
    - Rt
    - Wks
    - X25
    - A
    - AAAA
    - CName
    - Ptr
    - Srv
    - Txt
    - Wins
    - WinsR
    - Ns
    - Soa
    - NasP
    - NasPtr
    - DName
    - Gpos
    - Loc
    - DhcId
    - Naptr
    - RRSig
    - DnsKey
    - DS
    - NSec
    - NSec3
    - NSec3Param
    - Tlsa
  -RecordData String[]: ~
  -ThrottleLimit Int32: ~
  -Type UInt16:
    required: true
  -VirtualizationInstance String: ~
  -WhatIf,-wi Switch: ~
  -ZoneName,-ForwardLookupZone String:
    required: true
  -ZoneScope String: ~
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
