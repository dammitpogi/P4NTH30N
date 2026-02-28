description: Gets a list of the app packages that are installed in a user profile
synopses:
- Get-AppxPackage [-AllUsers] [-PackageTypeFilter <PackageTypes>] [[-Name] <String>]
  [[-Publisher] <String>] [-User <String>] [-Volume <AppxVolume>] [<CommonParameters>]
options:
  -AllUsers Switch: ~
  -Name String: ~
  -PackageTypeFilter PackageTypes:
    values:
    - None
    - Main
    - Framework
    - Resource
    - Bundle
    - Xap
  -Publisher String: ~
  -User String: ~
  -Volume AppxVolume: ~
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
