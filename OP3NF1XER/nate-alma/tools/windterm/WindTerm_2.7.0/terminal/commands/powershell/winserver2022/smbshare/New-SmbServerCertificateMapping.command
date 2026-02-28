description: Creates a certificate association with the SMB server for SMB over QUIC
synopses:
- New-SmbServerCertificateMapping [-Name] <String> [-Thumbprint] <String> [-StoreName]
  <String> [-Subject <String>] [-DisplayName <String>] [-Type <Type>] [-Flags <Flags>]
  [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DisplayName String: ~
  -Flags Flags:
    values:
    - None
    - AllowNamedPipe
    - DefaultCert
  -Force Switch: ~
  -Name String:
    required: true
  -StoreName String:
    required: true
  -Subject String: ~
  -ThrottleLimit Int32: ~
  -Thumbprint String:
    required: true
  -Type Type:
    values:
    - QUIC
  -Confirm,-cf Switch: ~
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
