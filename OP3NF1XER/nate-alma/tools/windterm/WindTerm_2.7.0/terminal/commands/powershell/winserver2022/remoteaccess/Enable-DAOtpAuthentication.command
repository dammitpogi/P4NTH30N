description: Enables and configures one-time password (OTP) authentication for DirectAccess
  (DA) users
synopses:
- Enable-DAOtpAuthentication [-RadiusServer <String>] [-ComputerName <String>] [-RadiusPort
  <UInt16>] [-CAServer <String[]>] [-CertificateTemplateName <String>] [-SharedSecret
  <String>] [-UserSecurityGroupName <String>] [-Force] [-PassThru] [-SigningCertificateTemplateName
  <String>] [-CimSession <CimSession[]>] [-ThrottleLimit <Int32>] [-AsJob] [-WhatIf]
  [-Confirm] [<CommonParameters>]
options:
  -AsJob Switch: ~
  -CAServer String[]: ~
  -CertificateTemplateName String: ~
  -CimSession,-Session CimSession[]: ~
  -ComputerName,-Cn String: ~
  -Confirm,-cf Switch: ~
  -Force Switch: ~
  -PassThru Switch: ~
  -RadiusPort,-Port UInt16: ~
  -RadiusServer,-Server String: ~
  -SharedSecret String: ~
  -SigningCertificateTemplateName String: ~
  -ThrottleLimit Int32: ~
  -UserSecurityGroupName String: ~
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
