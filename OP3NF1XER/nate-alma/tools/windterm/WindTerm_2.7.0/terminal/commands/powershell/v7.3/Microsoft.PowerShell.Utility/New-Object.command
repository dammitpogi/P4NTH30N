description: Creates an instance of a Microsoft .NET Framework or COM object
synopses:
- New-Object [-TypeName] <String> [[-ArgumentList] <Object[]>] [-Property <IDictionary>]
  [<CommonParameters>]
- New-Object [-ComObject] <String> [-Strict] [-Property <IDictionary>] [<CommonParameters>]
options:
  -ArgumentList,-Args System.Object[]: ~
  -ComObject System.String:
    required: true
  -Property System.Collections.IDictionary: ~
  -Strict Switch: ~
  -TypeName System.String:
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
