description: Merges test result information from several .hckx package files into
  a single test collection
synopses:
- Merge-HwCertTestCollectionFromPackage [-LiteralPath] <String[]> [-Force] [-IncludeAll]
  [-ValidationXmlPath <String>] [-HckBuildVersion <String>] [<CommonParameters>]
options:
  -Force Switch: ~
  -HckBuildVersion,-Build,-Version String: ~
  -IncludeAll Switch: ~
  -LiteralPath String[]:
    required: true
  -ValidationXmlPath,-XML String: ~
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
