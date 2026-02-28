description: Retrieves and displays the list of BPA models installed on the system
synopses:
- Get-BpaModel [-RepositoryPath <String>] [<CommonParameters>]
- Get-BpaModel [-ModelId] <String[]> [[-SubModelId] <String>] [-RepositoryPath <String>]
  [<CommonParameters>]
options:
  -ModelId,-Id,-BestPracticesModelId String[]:
    required: true
  -RepositoryPath String: ~
  -SubModelId String: ~
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
