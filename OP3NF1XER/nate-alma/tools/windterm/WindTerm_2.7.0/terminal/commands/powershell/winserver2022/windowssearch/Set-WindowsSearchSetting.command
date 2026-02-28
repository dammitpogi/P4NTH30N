description: Modifies values that control Windows Search
synopses:
- Set-WindowsSearchSetting [-EnableWebResultsSetting <Boolean>] [-EnableMeteredWebResultsSetting
  <Boolean>] [-SearchExperienceSetting <String>] [-SafeSearchSetting <String>] [<CommonParameters>]
options:
  -EnableMeteredWebResultsSetting Boolean: ~
  -EnableWebResultsSetting Boolean: ~
  -SafeSearchSetting String:
    values:
    - Strict
    - Moderate
    - Off
  -SearchExperienceSetting String:
    values:
    - PersonalizedAndLocation
    - Personalized
    - NotPersonalized
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
