description: Merges test result information from several test collection files into
  a single test collection
synopses:
- Merge-HwCertTestCollectionFromXml [-LiteralPath] <String[]> [-ValidationXmlPath
  <String>] [-HckBuildVersion <String>] [<CommonParameters>]
options:
  -HckBuildVersion,-Build,-Version String: ~
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
