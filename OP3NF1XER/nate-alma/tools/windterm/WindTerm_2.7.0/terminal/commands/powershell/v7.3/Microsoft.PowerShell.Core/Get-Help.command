description: Displays information about PowerShell commands and concepts
synopses:
- Get-Help [[-Name] <String>] [-Path <String>] [-Category <String[]>] [-Full] [-Component
  <String[]>] [-Functionality <String[]>] [-Role <String[]>] [<CommonParameters>]
- Get-Help [[-Name] <String>] [-Path <String>] [-Category <String[]>] -Detailed [-Component
  <String[]>] [-Functionality <String[]>] [-Role <String[]>] [<CommonParameters>]
- Get-Help [[-Name] <String>] [-Path <String>] [-Category <String[]>] -Examples [-Component
  <String[]>] [-Functionality <String[]>] [-Role <String[]>] [<CommonParameters>]
- Get-Help [[-Name] <String>] [-Path <String>] [-Category <String[]>] -Parameter <String[]>
  [-Component <String[]>] [-Functionality <String[]>] [-Role <String[]>] [<CommonParameters>]
- Get-Help [[-Name] <String>] [-Path <String>] [-Category <String[]>] [-Component
  <String[]>] [-Functionality <String[]>] [-Role <String[]>] -Online [<CommonParameters>]
- Get-Help [[-Name] <String>] [-Path <String>] [-Category <String[]>] [-Component
  <String[]>] [-Functionality <String[]>] [-Role <String[]>] -ShowWindow [<CommonParameters>]
options:
  -Category System.String[]:
    values:
    - Alias
    - Cmdlet
    - Provider
    - General
    - FAQ
    - Glossary
    - HelpFile
    - ScriptCommand
    - Function
    - Filter
    - ExternalScript
    - All
    - DefaultHelp
    - Workflow
    - DscResource
    - Class
    - Configuration
  -Component System.String[]: ~
  -Detailed Switch:
    required: true
  -Examples Switch:
    required: true
  -Full Switch: ~
  -Functionality System.String[]: ~
  -Name System.String: ~
  -Online Switch:
    required: true
  -Parameter System.String[]:
    required: true
  -Path System.String: ~
  -Role System.String[]: ~
  -ShowWindow Switch:
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
