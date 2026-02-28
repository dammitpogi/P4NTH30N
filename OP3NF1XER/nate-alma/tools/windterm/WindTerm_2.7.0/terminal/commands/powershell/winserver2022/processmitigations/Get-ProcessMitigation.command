description: Gets the current process mitigation settings, either from the registry,
  from a running process, or saves all to a XML
synopses:
- Get-ProcessMitigation [-FullPolicy] [<CommonParameters>]
- Get-ProcessMitigation [-Name] <String> [-RunningProcesses] [<CommonParameters>]
- Get-ProcessMitigation [-Id] <Int32[]> [<CommonParameters>]
- Get-ProcessMitigation [-RegistryConfigFilePath <String>] [<CommonParameters>]
- Get-ProcessMitigation [-System] [<CommonParameters>]
options:
  -FullPolicy,-f Switch: ~
  -Id Int32[]:
    required: true
  -Name,-n String:
    required: true
  -RegistryConfigFilePath,-o String: ~
  -RunningProcesses,-r Switch: ~
  -System,-s Switch: ~
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
