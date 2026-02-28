description: Retrieves and displays the results of the most recent Best Practices
  Analyzer (BPA) scan for a specific model
synopses:
- Get-BpaResult [-ModelId] <String> [-CollectedConfiguration] [-All] [-Filter <FilterOptions>]
  [-RepositoryPath <String>] [<CommonParameters>]
- Get-BpaResult [-ModelId] <String> [-CollectedConfiguration] [-All] [-Filter <FilterOptions>]
  [-RepositoryPath <String>] [-SubModelId <String>] [-ComputerName <String[]>] [-Context
  <String>] [<CommonParameters>]
options:
  -All Switch: ~
  -CollectedConfiguration Switch: ~
  -ComputerName String[]: ~
  -Context String: ~
  -Filter FilterOptions:
    values:
    - All
    - Compliant
    - Noncompliant
  -ModelId,-Id,-BestPracticesModelId String:
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
