description: Modifies the management information that is related to a resource
synopses:
- Set-WSManInstance [-ApplicationName <String>] [-ComputerName <String>] [-Dialect
  <Uri>] [-FilePath <String>] [-Fragment <String>] [-OptionSet <Hashtable>] [-Port
  <Int32>] [-ResourceURI] <Uri> [[-SelectorSet] <Hashtable>] [-SessionOption <SessionOption>]
  [-UseSSL] [-ValueSet <Hashtable>] [-Credential <PSCredential>] [-Authentication
  <AuthenticationMechanism>] [-CertificateThumbprint <String>] [<CommonParameters>]
- Set-WSManInstance [-ConnectionURI <Uri>] [-Dialect <Uri>] [-FilePath <String>] [-Fragment
  <String>] [-OptionSet <Hashtable>] [-ResourceURI] <Uri> [[-SelectorSet] <Hashtable>]
  [-SessionOption <SessionOption>] [-ValueSet <Hashtable>] [-Credential <PSCredential>]
  [-Authentication <AuthenticationMechanism>] [-CertificateThumbprint <String>] [<CommonParameters>]
options:
  -ApplicationName System.String: ~
  -Authentication,-auth,-am Microsoft.WSMan.Management.AuthenticationMechanism: ~
  -CertificateThumbprint System.String: ~
  -ComputerName,-cn System.String: ~
  -ConnectionURI System.Uri: ~
  -Credential,-cred,-c System.Management.Automation.PSCredential: ~
  -Dialect System.Uri: ~
  -FilePath,-Path System.String: ~
  -Fragment System.String: ~
  -OptionSet,-os System.Collections.Hashtable: ~
  -Port System.Int32: ~
  -ResourceURI,-ruri System.Uri:
    required: true
  -SelectorSet System.Collections.Hashtable: ~
  -SessionOption,-so Microsoft.WSMan.Management.SessionOption: ~
  -UseSSL,-ssl Switch: ~
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
