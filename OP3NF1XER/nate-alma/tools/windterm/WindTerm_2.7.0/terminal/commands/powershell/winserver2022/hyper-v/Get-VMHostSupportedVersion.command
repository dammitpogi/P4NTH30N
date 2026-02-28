description: Returns a list of virtual machine configuration versions that are supported
  on a host
synopses:
- Get-VMHostSupportedVersion [[-ComputerName] <String[]>] [[-Credential] <PSCredential[]>]
  [-Default] [<CommonParameters>]
- Get-VMHostSupportedVersion [-CimSession] <CimSession[]> [-Default] [<CommonParameters>]
options:
  -CimSession CimSession[]:
    required: true
  -ComputerName String[]: ~
  -Credential PSCredential[]: ~
  -Default Switch: ~
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
