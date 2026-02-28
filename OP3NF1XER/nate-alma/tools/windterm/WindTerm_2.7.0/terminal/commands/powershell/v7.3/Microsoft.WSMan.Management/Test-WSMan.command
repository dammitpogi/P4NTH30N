description: Tests whether the WinRM service is running on a local or remote computer
synopses:
- Test-WSMan [[-ComputerName] <String>] [-Authentication <AuthenticationMechanism>]
  [-Port <Int32>] [-UseSSL] [-ApplicationName <String>] [-Credential <PSCredential>]
  [-CertificateThumbprint <String>] [<CommonParameters>]
options:
  -ApplicationName System.String: ~
  -Authentication,-auth,-am Microsoft.WSMan.Management.AuthenticationMechanism:
    values:
    - None
    - Default
    - Digest
    - Negotiate
    - Basic
    - Kerberos
    - ClientCertificate
    - Credssp
  -CertificateThumbprint System.String: ~
  -ComputerName,-cn System.String: ~
  -Credential,-cred,-c System.Management.Automation.PSCredential: ~
  -Port System.Int32: ~
  -UseSSL Switch: ~
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
