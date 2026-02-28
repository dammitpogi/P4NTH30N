description: Gets resource records from a specified DNS zone
synopses:
- Get-DnsServerResourceRecord [[-Name] <String>] [-ComputerName <String>] [-ZoneName]
  <String> [-Node] [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Type]
  <UInt16> [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
- Get-DnsServerResourceRecord [[-Name] <String>] [-ComputerName <String>] [-ZoneName]
  <String> [-Node] [-ZoneScope <String>] [-VirtualizationInstance <String>] [-RRType
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn,-ForwardLookupPrimaryServer String: ~
  -Name String: ~
  -Node Switch: ~
  -RRType String:
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
  -ThrottleLimit Int32: ~
  -Type UInt16:
    required: true
  -VirtualizationInstance String: ~
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
