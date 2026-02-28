description: Retrieves a certificate associated with the SMB server for SMB over QUIC
synopses:
- Get-SmbServerCertificateMapping [[-Name] <String[]>] [[-Subject] <String[]>] [-Thumbprint
  <String[]>] [-DisplayName <String[]>] [-StoreName <String[]>] [-Type <Type[]>] [-Flags
  <Flags[]>] [-IncludeHidden] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>]
  [-AsJob] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CimSession,-Session CimSession[]: ~
  -DisplayName String[]: ~
  -Flags Flags[]:
    values:
    - None
    - AllowNamedPipe
    - DefaultCert
  -IncludeHidden Switch: ~
  -Name String[]: ~
  -StoreName String[]: ~
  -Subject String[]: ~
  -ThrottleLimit Int32: ~
  -Thumbprint String[]: ~
  -Type Type[]:
    values:
    - QUIC
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
