description: Adds a type A resource record to a DNS zone
synopses:
- Add-DnsServerResourceRecordA [-AllowUpdateAny] [-CreatePtr] [-Name] <String> [-IPv4Address]
  <IPAddress[]> [-ComputerName <String>] [-TimeToLive <TimeSpan>] [-ZoneName] <String>
  [-AgeRecord] [-PassThru] [-ZoneScope <String>] [-VirtualizationInstance <String>]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AgeRecord Switch: ~
  -AllowUpdateAny Switch: ~
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn,-ForwardLookupPrimaryServer String: ~
  -Confirm,-cf Switch: ~
  -CreatePtr Switch: ~
  -IPv4Address,-IpAddress IPAddress[]:
    required: true
  -Name,-DeviceName String:
    required: true
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -TimeToLive TimeSpan: ~
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
