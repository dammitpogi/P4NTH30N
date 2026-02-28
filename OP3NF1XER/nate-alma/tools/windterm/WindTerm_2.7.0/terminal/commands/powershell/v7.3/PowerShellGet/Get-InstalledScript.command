description: Gets an installed script
synopses:
- Get-InstalledScript [[-Name] <String[]>] [-MinimumVersion <String>] [-RequiredVersion
  <String>] [-MaximumVersion <String>] [-AllowPrerelease] [<CommonParameters>]
options:
  -AllowPrerelease Switch: ~
  -MaximumVersion System.String: ~
  -MinimumVersion System.String: ~
  -Name System.String[]: ~
  -RequiredVersion System.String: ~
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
