description: Gets information about Windows Server roles, role services, and features
  that are available for installation and installed on a specified server
synopses:
- Get-WindowsFeature [[-Name] <String[]>] [-Vhd <String>] [-ComputerName <String>]
  [-Credential <PSCredential>] [-LogPath <String>] [<CommonParameters>]
options:
  -ComputerName,-Cn String: ~
  -Credential PSCredential: ~
  -LogPath String: ~
  -Name String[]: ~
  -Vhd String: ~
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
