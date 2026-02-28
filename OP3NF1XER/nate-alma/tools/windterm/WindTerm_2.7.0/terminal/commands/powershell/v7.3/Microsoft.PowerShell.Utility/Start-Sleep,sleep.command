description: Suspends the activity in a script or session for the specified period
  of time
synopses:
- Start-Sleep [-Seconds] <Double> [<CommonParameters>]
- Start-Sleep -Milliseconds <Int32> [<CommonParameters>]
- Start-Sleep -Duration <TimeSpan> [<CommonParameters>]
options:
  -Duration,-ts System.TimeSpan:
    required: true
  -Milliseconds,-ms System.Int32:
    required: true
  -Seconds System.Double:
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
