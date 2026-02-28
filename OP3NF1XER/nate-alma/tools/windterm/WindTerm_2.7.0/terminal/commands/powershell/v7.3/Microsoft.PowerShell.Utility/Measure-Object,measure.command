description: Calculates the numeric properties of objects, and the characters, words,
  and lines in string objects, such as files of text
synopses:
- Measure-Object [[-Property] <PSPropertyExpression[]>] [-InputObject <PSObject>]
  [-StandardDeviation] [-Sum] [-AllStats] [-Average] [-Maximum] [-Minimum] [<CommonParameters>]
- Measure-Object [[-Property] <PSPropertyExpression[]>] [-InputObject <PSObject>]
  [-Line] [-Word] [-Character] [-IgnoreWhiteSpace] [<CommonParameters>]
options:
  -AllStats Switch: ~
  -Average Switch: ~
  -Character Switch: ~
  -IgnoreWhiteSpace Switch: ~
  -InputObject System.Management.Automation.PSObject: ~
  -Line Switch: ~
  -Maximum Switch: ~
  -Minimum Switch: ~
  -Property Microsoft.PowerShell.Commands.PSPropertyExpression[]: ~
  -StandardDeviation Switch: ~
  -Sum Switch: ~
  -Word Switch: ~
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
