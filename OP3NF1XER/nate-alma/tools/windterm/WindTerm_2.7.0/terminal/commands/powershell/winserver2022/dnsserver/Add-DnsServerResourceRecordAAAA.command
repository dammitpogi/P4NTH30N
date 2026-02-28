description: Adds a type AAAA resource record to a DNS server
synopses:
- Add-DnsServerResourceRecordAAAA [-AllowUpdateAny] [-CreatePtr] [-IPv6Address] <IPAddress[]>
  [-Name] <String> [-ComputerName <String>] [-TimeToLive <TimeSpan>] [-ZoneName] <String>
  [-AgeRecord] [-PassThru] [-ZoneScope <String>] [-VirtualizationInstance <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AgeRecord Switch: ~
  -AllowUpdateAny Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -CreatePtr Switch: ~
  -IPv6Address IPAddress[]:
    required: true
  -Name String:
    required: true
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -TimeToLive TimeSpan: ~
  -VirtualizationInstance String: ~
  -WhatIf,-wi Switch: ~
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
