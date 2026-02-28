description: Modifies the properties of an IPv4 reservation
synopses:
- Set-DhcpServerv4Reservation [-ComputerName <String>] [-IPAddress] <IPAddress> [-ClientId
  <String>] [-Name <String>] [-Description <String>] [-Type <String>] [-PassThru]
  [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -ClientId String: ~
  -ComputerName,-Cn,-ReservationServer String: ~
  -Confirm,-cf Switch: ~
  -Description,-ReservationDescription String: ~
  -IPAddress,-ReservedIP IPAddress:
    required: true
  -Name,-HostName,-ReservationName String: ~
  -PassThru Switch: ~
  -ThrottleLimit Int32: ~
  -Type,-ReservationType String:
    values:
    - Dhcp
    - Bootp
    - Both
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
