description: Start an Event Trace logging session
synopses:
- Start-Trace [-SessionName] <String> [[-OutputFilePath] <String>] [[-ProviderFilePath]
  <String>] [-ETS] [-Format <String>] [-MinBuffers <Int32>] [-MaxBuffers <Int32>]
  [-BufferSizeInKB <Int32>] [-MaxLogFileSizeInMB <Int32>] [<CommonParameters>]
options:
  -BufferSizeInKB System.Int32: ~
  -ETS Switch: ~
  -Format System.Object:
    values:
    - bin
    - bincirc
    - csv
    - tsv
    - sql
  -MaxBuffers System.Int32: ~
  -MaxLogFileSizeInMB System.Int32: ~
  -MinBuffers System.Int32: ~
  -OutputFilePath System.String: ~
  -ProviderFilePath System.String: ~
  -SessionName System.String:
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
