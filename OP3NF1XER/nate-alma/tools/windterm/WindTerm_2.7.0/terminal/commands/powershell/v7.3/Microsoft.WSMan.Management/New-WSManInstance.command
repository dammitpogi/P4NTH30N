description: Creates a new instance of a management resource
synopses:
- New-WSManInstance [-ApplicationName <String>] [-ComputerName <String>] [-FilePath
  <String>] [-OptionSet <Hashtable>] [-Port <Int32>] [-ResourceURI] <Uri> [-SelectorSet]
  <Hashtable> [-SessionOption <SessionOption>] [-UseSSL] [-ValueSet <Hashtable>] [-Credential
  <PSCredential>] [-Authentication <AuthenticationMechanism>] [-CertificateThumbprint
  <String>] [<CommonParameters>]
- New-WSManInstance [-ConnectionURI <Uri>] [-FilePath <String>] [-OptionSet <Hashtable>]
  [-ResourceURI] <Uri> [-SelectorSet] <Hashtable> [-SessionOption <SessionOption>]
  [-ValueSet <Hashtable>] [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
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
  -ConnectionURI,-CURI,-CU System.Uri: ~
  -Credential,-cred,-c System.Management.Automation.PSCredential: ~
  -FilePath,-Path System.String: ~
  -OptionSet,-os System.Collections.Hashtable: ~
  -Port System.Int32: ~
  -ResourceURI,-ruri System.Uri:
    required: true
  -SelectorSet System.Collections.Hashtable:
    required: true
  -SessionOption,-so Microsoft.WSMan.Management.SessionOption: ~
  -UseSSL Switch: ~
  -ValueSet System.Collections.Hashtable: ~
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
