description: Creates a SAML protocol endpoint object
synopses:
- New-AdfsSamlEndpoint -Binding <String> -Protocol <String> -Uri <Uri> [-IsDefault
  <Boolean>] [-Index <Int32>] [-ResponseUri <Uri>] [<CommonParameters>]
options:
  -Binding String:
    required: true
    values:
    - Artifact
    - POST
    - Redirect
    - SOAP
  -Index Int32: ~
  -IsDefault Boolean: ~
  -Protocol String:
    required: true
    values:
    - SAMLArtifactResolution
    - SAMLAssertionConsumer
    - SAMLLogout
    - SAMLSingleSignOn
  -ResponseUri Uri: ~
  -Uri Uri:
    required: true
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
