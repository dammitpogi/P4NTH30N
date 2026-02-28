description: Finds modules in a repository that match specified criteria
synopses:
- Find-Module [[-Name] <string[]>] [-MinimumVersion <string>] [-MaximumVersion <string>]
  [-RequiredVersion <string>] [-AllVersions] [-IncludeDependencies] [-Filter <string>]
  [-Tag <string[]>] [-Includes <string[]>] [-DscResource <string[]>] [-RoleCapability
  <string[]>] [-Command <string[]>] [-Proxy <uri>] [-ProxyCredential <pscredential>]
  [-Repository <string[]>] [-Credential <pscredential>] [-AllowPrerelease] [<CommonParameters>]
options:
  -AllowPrerelease Switch: ~
  -AllVersions Switch: ~
  -Command System.String[]: ~
  -Credential System.Management.Automation.PSCredential: ~
  -DscResource System.String[]: ~
  -Filter System.String: ~
  -IncludeDependencies Switch: ~
  -Includes System.String[]:
    values:
    - DscResource
    - Cmdlet
    - Function
    - RoleCapability
  -MaximumVersion System.String: ~
  -MinimumVersion System.String: ~
  -Name System.String[]: ~
  -Proxy System.Uri: ~
  -ProxyCredential System.Management.Automation.PSCredential: ~
  -Repository System.String[]: ~
  -RequiredVersion System.String: ~
  -RoleCapability System.String[]: ~
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
