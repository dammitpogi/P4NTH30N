description: Registers a PowerShell repository
synopses:
- Register-PSRepository [-Name] <String> [-SourceLocation] <Uri> [-PublishLocation
  <Uri>] [-ScriptSourceLocation <Uri>] [-ScriptPublishLocation <Uri>] [-Credential
  <PSCredential>] [-InstallationPolicy <String>] [-Proxy <Uri>] [-ProxyCredential
  <PSCredential>] [-PackageManagementProvider <String>] [<CommonParameters>]
- Register-PSRepository [-Default] [-InstallationPolicy <String>] [-Proxy <Uri>] [-ProxyCredential
  <PSCredential>] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Default Switch:
    required: true
  -InstallationPolicy System.String:
    values:
    - Trusted
    - Untrusted
  -Name System.String:
    required: true
  -PackageManagementProvider System.String: ~
  -Proxy System.Uri: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -PublishLocation System.Uri: ~
  -ScriptPublishLocation System.Uri: ~
  -ScriptSourceLocation System.Uri: ~
  -SourceLocation System.Uri:
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
