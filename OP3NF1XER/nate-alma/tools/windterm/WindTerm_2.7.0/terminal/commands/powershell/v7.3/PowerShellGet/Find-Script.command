description: Finds a script
synopses:
- Find-Script [[-Name] <String[]>] [-MinimumVersion <String>] [-MaximumVersion <String>]
  [-RequiredVersion <String>] [-AllVersions] [-IncludeDependencies] [-Filter <String>]
  [-Tag <String[]>] [-Includes <String[]>] [-Command <String[]>] [-Proxy <Uri>] [-ProxyCredential
  <PSCredential>] [-Repository <String[]>] [-Credential <PSCredential>] [-AllowPrerelease]
  [<CommonParameters>]
options:
  -AllowPrerelease Switch: ~
  -AllVersions Switch: ~
  -Command System.String[]: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Filter System.String: ~
  -IncludeDependencies Switch: ~
  -Includes System.String[]:
    values:
    - Function
    - Workflow
  -MaximumVersion System.String: ~
  -MinimumVersion System.String: ~
  -Name System.String[]: ~
  -Proxy System.Uri: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -Repository System.String[]: ~
  -RequiredVersion System.String: ~
  -Tag System.String[]: ~
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
