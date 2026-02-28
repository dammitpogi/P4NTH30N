description: Deletes a management resource instance
synopses:
- Remove-WSManInstance [-ApplicationName <String>] [-ComputerName <String>] [-OptionSet
  <Hashtable>] [-Port <Int32>] [-ResourceURI] <Uri> [-SelectorSet] <Hashtable> [-SessionOption
  <SessionOption>] [-UseSSL] [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
  [-CertificateThumbprint <String>] [<CommonParameters>]
- Remove-WSManInstance [-ConnectionURI <Uri>] [-OptionSet <Hashtable>] [-ResourceURI]
  <Uri> [-SelectorSet] <Hashtable> [-SessionOption <SessionOption>] [-Credential <PSCredential>]
  [-Authentication <AuthenticationMechanism>] [-CertificateThumbprint <String>] [<CommonParameters>]
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
  -ResourceURI,-ruri System.Uri:
    required: true
  -SelectorSet System.Collections.Hashtable:
    required: true
  -SessionOption,-so Microsoft.WSMan.Management.SessionOption: ~
  -UseSSL,-ssl Switch: ~
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
