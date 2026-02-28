description: Adds a resource record of a specified type to a specified DNS zone
synopses:
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-AllowUpdateAny] -InputObject
  <CimInstance> [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -PsdnAddress <String> [-X25] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -InternetAddress <IPAddress> -InternetProtocol
  <String> -Service <String[]> [-Wks] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Force] -LookupTimeout
  <TimeSpan> [-Replicate] -CacheTimeout <TimeSpan> -ResultDomain <String> [-WinsR]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Force] -LookupTimeout
  <TimeSpan> [-Replicate] -WinsServers <IPAddress[]> -CacheTimeout <TimeSpan> [-Wins]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] [-Type] <UInt16> [-RecordData] <String>
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -DescriptiveText <String> [-Txt] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [[-Name] <String>] [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] [-TLSA] -CertificateUsage <String> -MatchingType
  <String> -Selector <String> -CertificateAssociationData <String> [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -DomainName <String> -Priority <UInt16>
  -Weight <UInt16> -Port <UInt16> [-Srv] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -Preference <UInt16> -IntermediateHost
  <String> [-RT] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -ResponsiblePerson <String> -Description
  <String> [-RP] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -PtrDomainName <String> [-Ptr] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -NameServer <String> [-NS] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -MailExchange <String> -Preference <UInt16>
  [-MX] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -IsdnNumber <String> -IsdnSubAddress
  <String> [-Isdn] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob]
  [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -Cpu <String> -OperatingSystem <String>
  [-HInfo] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -DomainNameAlias <String> [-DName] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -DhcpIdentifier <String> [-DhcId] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -HostNameAlias <String> [-CName] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -Address <String> -AddressType <String>
  [-Atma] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-Name] <String> [-TimeToLive
  <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -SubType <UInt16> -ServerName <String>
  [-Afsdb] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-CreatePtr] [-Name] <String>
  [-TimeToLive <TimeSpan>] [-AgeRecord] [-AllowUpdateAny] -IPv6Address <IPAddress>
  [-AAAA] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
- Add-DnsServerResourceRecord [-ZoneName] <String> [-ComputerName <String>] [-PassThru]
  [-ZoneScope <String>] [-VirtualizationInstance <String>] [-CreatePtr] -IPv4Address
  <IPAddress> [-Name] <String> [-TimeToLive <TimeSpan>] [-AgeRecord] [-AllowUpdateAny]
  [-A] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -A Switch:
    required: true
  -AAAA Switch:
    required: true
  -Address String:
    required: true
  -AddressType String:
    required: true
    values:
    - E164
    - AESA
  -Afsdb Switch:
    required: true
  -AgeRecord Switch: ~
  -AllowUpdateAny Switch: ~
  -AsJob Switch: ~
  -Atma Switch:
    required: true
  -CName Switch:
    required: true
  -CacheTimeout TimeSpan:
    required: true
  -CertificateAssociationData String:
    required: true
  -CertificateUsage String:
    required: true
    values:
    - CAConstraint
    - ServiceCertificateConstraint
    - TrustAnchorAssertion
    - DomainIssuedCertificate
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Cpu String:
    required: true
  -CreatePtr Switch: ~
  -DName Switch:
    required: true
  -Description String:
    required: true
  -DescriptiveText String:
    required: true
  -DhcId Switch:
    required: true
  -DhcpIdentifier String:
    required: true
  -DomainName String:
    required: true
  -DomainNameAlias String:
    required: true
  -Force Switch: ~
  -HInfo Switch:
    required: true
  -HostNameAlias String:
    required: true
  -IPv4Address IPAddress:
    required: true
  -IPv6Address IPAddress:
    required: true
  -InputObject CimInstance:
    required: true
  -IntermediateHost String:
    required: true
  -InternetAddress IPAddress:
    required: true
  -InternetProtocol String:
    required: true
    values:
    - UDP
    - TCP
  -Isdn Switch:
    required: true
  -IsdnNumber String:
    required: true
  -IsdnSubAddress String:
    required: true
  -LookupTimeout TimeSpan:
    required: true
  -MX Switch:
    required: true
  -MailExchange String:
    required: true
  -MatchingType String:
    required: true
    values:
    - ExactMatch
    - Sha256Hash
    - Sha512Hash
  -NS Switch:
    required: true
  -Name String:
    required: true
  -NameServer String:
    required: true
  -OperatingSystem String:
    required: true
  -PassThru Switch: ~
  -Port UInt16:
    required: true
  -Preference UInt16:
    required: true
  -Priority UInt16:
    required: true
  -PsdnAddress String:
    required: true
  -Ptr Switch:
    required: true
  -PtrDomainName String:
    required: true
  -RP Switch:
    required: true
  -RT Switch:
    required: true
  -RecordData String:
    required: true
  -Replicate Switch: ~
  -ResponsiblePerson String:
    required: true
  -ResultDomain String:
    required: true
  -Selector String:
    required: true
    values:
    - FullCertificate
    - SubjectPublicKeyInfo
  -ServerName String:
    required: true
  -Service String[]:
    required: true
  -Srv Switch:
    required: true
  -SubType UInt16:
    required: true
  -TLSA Switch:
    required: true
  -ThrottleLimit Int32: ~
  -TimeToLive TimeSpan: ~
  -Txt Switch:
    required: true
  -Type UInt16:
    required: true
  -VirtualizationInstance String: ~
  -Weight UInt16:
    required: true
  -WhatIf,-wi Switch: ~
  -Wins Switch:
    required: true
  -WinsR Switch:
    required: true
  -WinsServers IPAddress[]:
    required: true
  -Wks Switch:
    required: true
  -X25 Switch:
    required: true
  -ZoneName String:
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
