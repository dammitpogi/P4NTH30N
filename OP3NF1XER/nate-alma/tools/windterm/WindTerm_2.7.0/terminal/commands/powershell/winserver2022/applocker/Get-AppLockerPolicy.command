description: Gets the local, the effective, or a domain AppLocker policy
synopses:
- Get-AppLockerPolicy [-Local] [-Xml] [<CommonParameters>]
- Get-AppLockerPolicy [-Domain] -Ldap <String> [-Xml] [<CommonParameters>]
- Get-AppLockerPolicy [-Effective] [-Xml] [<CommonParameters>]
options:
  -Domain Switch:
    required: true
  -Effective Switch:
    required: true
  -Ldap String:
    required: true
  -Local Switch:
    required: true
  -Xml Switch: ~
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
