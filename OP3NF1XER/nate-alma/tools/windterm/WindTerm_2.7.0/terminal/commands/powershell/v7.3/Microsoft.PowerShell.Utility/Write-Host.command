description: Writes customized output to a host
synopses:
- Write-Host [[-Object] <Object>] [-NoNewline] [-Separator <Object>] [-ForegroundColor
  <ConsoleColor>] [-BackgroundColor <ConsoleColor>] [<CommonParameters>]
options:
  -BackgroundColor System.ConsoleColor:
    values:
    - Black
    - DarkBlue
    - DarkGreen
    - DarkCyan
    - DarkRed
    - DarkMagenta
    - DarkYellow
    - Gray
    - DarkGray
    - Blue
    - Green
    - Cyan
    - Red
    - Magenta
    - Yellow
    - White
  -ForegroundColor System.ConsoleColor:
    values:
    - Black
    - DarkBlue
    - DarkGreen
    - DarkCyan
    - DarkRed
    - DarkMagenta
    - DarkYellow
    - Gray
    - DarkGray
    - Blue
    - Green
    - Cyan
    - Red
    - Magenta
    - Yellow
    - White
  -NoNewline Switch: ~
  -Object,-Msg,-Message System.Object: ~
  -Separator System.Object: ~
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
