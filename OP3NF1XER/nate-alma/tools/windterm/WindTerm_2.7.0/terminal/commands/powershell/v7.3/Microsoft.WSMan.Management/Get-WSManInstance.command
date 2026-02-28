description: Displays management information for a resource instance specified by
  a Resource URI
synopses:
- Get-WSManInstance [-ApplicationName <String>] [-ComputerName <String>] [-ConnectionURI
  <Uri>] [-Dialect <Uri>] [-Fragment <String>] [-OptionSet <Hashtable>] [-Port <Int32>]
  [-ResourceURI] <Uri> [-SelectorSet <Hashtable>] [-SessionOption <SessionOption>]
  [-UseSSL] [-Credential <PSCredential>] [-Authentication <AuthenticationMechanism>]
  [-CertificateThumbprint <String>] [<CommonParameters>]
- Get-WSManInstance [-ApplicationName <String>] [-BasePropertiesOnly] [-ComputerName
  <String>] [-ConnectionURI <Uri>] [-Dialect <Uri>] [-Enumerate] [-Filter <String>]
  [-OptionSet <Hashtable>] [-Port <Int32>] [-Associations] [-ResourceURI] <Uri> [-ReturnType
  <String>] [-SessionOption <SessionOption>] [-Shallow] [-UseSSL] [-Credential <PSCredential>]
  [-Authentication <AuthenticationMechanism>] [-CertificateThumbprint <String>] [<CommonParameters>]
options:
  -ApplicationName System.String: ~
  -Associations Switch: ~
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
  -BasePropertiesOnly,-UBPO,-Base Switch: ~
  -CertificateThumbprint System.String: ~
  -ComputerName,-CN System.String: ~
  -ConnectionURI,-CURI,-CU System.Uri: ~
  -Credential,-cred,-c System.Management.Automation.PSCredential: ~
  -Dialect System.Uri: ~
  -Enumerate Switch:
    required: true
  -Filter System.String: ~
  -Fragment System.String: ~
  -OptionSet,-OS System.Collections.Hashtable: ~
  -Port System.Int32: ~
  -ResourceURI,-RURI System.Uri:
    required: true
  -ReturnType,-RT System.String:
    values:
    - object
    - epr
    - objectandepr
  -SelectorSet System.Collections.Hashtable: ~
  -SessionOption,-SO Microsoft.WSMan.Management.SessionOption: ~
  -Shallow Switch: ~
  -UseSSL,-SSL Switch: ~
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
