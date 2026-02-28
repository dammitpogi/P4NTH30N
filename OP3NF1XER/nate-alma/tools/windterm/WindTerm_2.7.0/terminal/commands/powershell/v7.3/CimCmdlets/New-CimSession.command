description: Creates a CIM session
synopses:
- New-CimSession [-Authentication <PasswordAuthenticationMechanism>] [[-Credential]
  <PSCredential>] [[-ComputerName] <String[]>] [-Name <String>] [-OperationTimeoutSec
  <UInt32>] [-SkipTestConnection] [-Port <UInt32>] [-SessionOption <CimSessionOptions>]
  [<CommonParameters>]
- New-CimSession [-CertificateThumbprint <String>] [[-ComputerName] <String[]>] [-Name
  <String>] [-OperationTimeoutSec <UInt32>] [-SkipTestConnection] [-Port <UInt32>]
  [-SessionOption <CimSessionOptions>] [<CommonParameters>]
options:
  -Authentication Microsoft.Management.Infrastructure.Options.PasswordAuthenticationMechanism:
    values:
    - Default
    - Digest
    - Negotiate
    - Basic
    - Kerberos
    - NtlmDomain
    - CredSsp
  -CertificateThumbprint System.String: ~
  -ComputerName,-CN,-ServerName System.String[]: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Name System.String: ~
  -OperationTimeoutSec,-OT System.UInt32: ~
  -Port System.UInt32: ~
  -SessionOption Microsoft.Management.Infrastructure.Options.CimSessionOptions: ~
  -SkipTestConnection Switch: ~
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
