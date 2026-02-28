description: Adds a new IPv4 address lease in the DHCP server service
synopses:
- Add-DhcpServerv4Lease [-IPAddress] <IPAddress> [-ScopeId] <IPAddress> [-ClientId]
  <String> [-AddressState <String>] [-HostName <String>] [-Description <String>] [-ComputerName
  <String>] [-PassThru] [-DnsRR <String>] [-DnsRegistration <String>] [-ClientType
  <String>] [-LeaseExpiryTime <DateTime>] [-NapCapable <Boolean>] [-NapStatus <String>]
  [-ProbationEnds <DateTime>] [-PolicyName <String>] [-CimSession <CimSession[]>]
  [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AddressState String:
    values:
    - Active
    - Declined
    - Expired
    - ActiveReservation
    - InactiveReservation
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientId String:
    required: true
  -ClientType String:
    values:
    - UnSpecified
    - Dhcp
    - BootP
    - None
    - Both
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Description String: ~
  -DnsRR String:
    values:
    - A
    - PTR
    - AandPTR
    - NoRegistration
  -DnsRegistration String:
    values:
    - Complete
    - Pending
    - NotApplicable
  -HostName String: ~
  -IPAddress IPAddress:
    required: true
  -LeaseExpiryTime DateTime: ~
  -NapCapable Boolean: ~
  -NapStatus String:
    values:
    - FullAccess
    - RestrictedAccess
    - DropPacket
    - InProbation
    - Exempt
    - DefaultQuarantineSetting
    - NoQuarantineInfo
  -PassThru Switch: ~
  -PolicyName String: ~
  -ProbationEnds DateTime: ~
  -ScopeId IPAddress:
    required: true
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
