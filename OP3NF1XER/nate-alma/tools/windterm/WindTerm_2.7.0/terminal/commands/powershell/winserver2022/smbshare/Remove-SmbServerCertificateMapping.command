description: Removes a certificate mapping from the SMB server for SMB over QUIC
synopses:
- Remove-SmbServerCertificateMapping [-Name] <String[]> [[-Subject] <String[]>] [[-Thumbprint]
  <String[]>] [[-DisplayName] <String[]>] [[-StoreName] <String[]>] [[-Type] <Type[]>]
  [[-Flags] <Flags[]>] [-IncludeHidden] [-Force] [-CimSession <CimSession[]>] [-ThrottleLimit
  <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
- Remove-SmbServerCertificateMapping -InputObject <CimInstance[]> [-Force] [-CimSession
  <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-PassThru] [-WhatIf] [-Confirm]
  [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DisplayName String[]: ~
  -Flags Flags[]:
    values:
    - None
    - AllowNamedPipe
    - DefaultCert
  -Force Switch: ~
  -IncludeHidden Switch: ~
  -InputObject CimInstance[]:
    required: true
  -Name String[]:
    required: true
  -PassThru Switch: ~
  -StoreName String[]: ~
  -Subject String[]: ~
  -ThrottleLimit Int32: ~
  -Thumbprint String[]: ~
  -Type Type[]:
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
