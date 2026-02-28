description: Exports product data and product-key data from a VAMT database to a portable
  .cilx file
synopses:
- Export-VamtData -Products <Product[]> -OutputFile <String> [-DbConnectionString
  <String>] [-IncludeProductKeys] [-IncludeSensitiveInfo] [-DbCommandTimeout <Int32>]
  [<CommonParameters>]
options:
  -DbCommandTimeout Int32: ~
  -DbConnectionString String: ~
  -IncludeProductKeys Switch: ~
  -IncludeSensitiveInfo Switch: ~
  -OutputFile String:
    required: true
  -Products Product[]:
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
