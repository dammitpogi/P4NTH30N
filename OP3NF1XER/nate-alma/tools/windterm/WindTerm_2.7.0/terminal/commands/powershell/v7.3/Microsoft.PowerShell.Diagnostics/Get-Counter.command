description: Gets performance counter data from local and remote computers
synopses:
- Get-Counter [[-Counter] <String[]>] [-SampleInterval <Int32>] [-MaxSamples <Int64>]
  [-Continuous] [-ComputerName <String[]>] [<CommonParameters>]
- Get-Counter [-ListSet] <String[]> [-ComputerName <String[]>] [<CommonParameters>]
options:
  -ComputerName,-Cn System.String[]: ~
  -Continuous Switch: ~
  -Counter System.String[]: ~
  -ListSet System.String[]:
    required: true
  -MaxSamples System.Int64: ~
  -SampleInterval System.Int32: ~
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
