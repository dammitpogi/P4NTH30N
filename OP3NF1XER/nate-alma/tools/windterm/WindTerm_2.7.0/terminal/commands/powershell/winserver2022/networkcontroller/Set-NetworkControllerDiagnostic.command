description: Changes diagnostic settings for the Network Controller
synopses:
- Set-NetworkControllerDiagnostic [-LogScope <LogScope>] [-DiagnosticLogLocation <String>]
  [-LogLocationCredential <PSCredential>] [-UseLocalLogLocation] [-LogTimeLimitInDays
  <UInt32>] [-LogSizeLimitInMBs <UInt32>] [-LogLevel <LogLevel>] [-PassThru] [-Force]
  [-ComputerName <String>] [-UseSsl] [-Credential <PSCredential>] [-CertificateThumbprint
  <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -CertificateThumbprint String: ~
  -ComputerName String: ~
  -Confirm,-cf Switch: ~
  -Credential PSCredential: ~
  -DiagnosticLogLocation String: ~
  -Force Switch: ~
  -LogLevel LogLevel:
    values:
    - Error
    - Warning
    - Informational
    - Verbose
  -LogLocationCredential PSCredential: ~
  -LogScope LogScope:
    values:
    - Cluster
    - All
  -LogSizeLimitInMBs UInt32: ~
  -LogTimeLimitInDays UInt32: ~
  -PassThru Switch: ~
  -UseLocalLogLocation Switch: ~
  -UseSsl Switch: ~
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
