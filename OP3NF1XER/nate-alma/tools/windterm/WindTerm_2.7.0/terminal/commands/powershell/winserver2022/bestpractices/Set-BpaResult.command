description: Excludes or includes existing results of a BPA scan to display only the
  specified scan results
synopses:
- Set-BpaResult [[-Exclude] <Boolean>] [-Results] <System.Collections.Generic.List`1[Microsoft.BestPractices.CoreInterface.Result]>
  [[-RepositoryPath] <String>] [<CommonParameters>]
options:
  -Exclude Boolean: ~
  -RepositoryPath String: ~
  -Results System.Collections.Generic.List`1[Microsoft.BestPractices.CoreInterface.Result]:
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
