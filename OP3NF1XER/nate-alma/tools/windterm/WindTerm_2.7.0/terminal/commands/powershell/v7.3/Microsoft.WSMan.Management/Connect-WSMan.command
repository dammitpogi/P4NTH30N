description: Connects to the WinRM service on a remote computer
synopses:
- Connect-WSMan [-ApplicationName <String>] [[-ComputerName] <String>] [-OptionSet
  <Hashtable>] [-Port <Int32>] [-SessionOption <SessionOption>] [-UseSSL] [-Credential
  <PSCredential>] [-Authentication <AuthenticationMechanism>] [-CertificateThumbprint
  <String>] [<CommonParameters>]
- Connect-WSMan [-ConnectionURI <Uri>] [-OptionSet <Hashtable>] [-Port <Int32>] [-SessionOption
  <SessionOption>] [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
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
  -ConnectionURI System.Uri: ~
  -Credential,-cred,-c System.Management.Automation.PSCredential: ~
  -OptionSet,-os System.Collections.Hashtable: ~
  -Port System.Int32: ~
  -SessionOption,-so Microsoft.WSMan.Management.SessionOption: ~
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
