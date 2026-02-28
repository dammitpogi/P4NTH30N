description: Selects objects or object properties
synopses:
- Select-Object [-InputObject <PSObject>] [[-Property] <Object[]>] [-ExcludeProperty
  <String[]>] [-ExpandProperty <String>] [-Unique] [-Last <Int32>] [-First <Int32>]
  [-Skip <Int32>] [-Wait] [<CommonParameters>]
- Select-Object [-InputObject <PSObject>] [[-Property] <Object[]>] [-ExcludeProperty
  <String[]>] [-ExpandProperty <String>] [-Unique] [-SkipLast <Int32>] [<CommonParameters>]
- Select-Object [-InputObject <PSObject>] [-Unique] [-Wait] [-Index <Int32[]>] [<CommonParameters>]
- Select-Object [-InputObject <PSObject>] [-Unique] [-SkipIndex <Int32[]>] [<CommonParameters>]
options:
  -ExcludeProperty System.String[]: ~
  -ExpandProperty System.String: ~
  -First System.Int32: ~
  -Index System.Int32[]: ~
  -InputObject System.Management.Automation.PSObject: ~
  -Last System.Int32: ~
  -Property System.Object[]: ~
  -Skip System.Int32: ~
  -SkipIndex System.Int32[]: ~
  -SkipLast System.Int32: ~
  -Unique Switch: ~
  -Wait Switch: ~
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
