description: Sorts objects by property values
synopses:
- Sort-Object [-Stable] [-Descending] [-Unique] [-InputObject <PSObject>] [[-Property]
  <Object[]>] [-Culture <String>] [-CaseSensitive] [<CommonParameters>]
- Sort-Object [-Descending] [-Unique] -Top <Int32> [-InputObject <PSObject>] [[-Property]
  <Object[]>] [-Culture <String>] [-CaseSensitive] [<CommonParameters>]
- Sort-Object [-Descending] [-Unique] -Bottom <Int32> [-InputObject <PSObject>] [[-Property]
  <Object[]>] [-Culture <String>] [-CaseSensitive] [<CommonParameters>]
options:
  -Bottom System.Int32:
    required: true
  -CaseSensitive Switch: ~
  -Culture System.String: ~
  -Descending Switch: ~
  -InputObject System.Management.Automation.PSObject: ~
  -Property System.Object[]: ~
  -Stable Switch: ~
  -Top System.Int32:
    required: true
  -Unique Switch: ~
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
