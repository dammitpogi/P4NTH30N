description: Creates an XML-based representation of an object or objects and stores
  it in a file
synopses:
- Export-Clixml [-Depth <Int32>] [-Path] <String> -InputObject <PSObject> [-Force]
  [-NoClobber] [-Encoding <Encoding>] [-WhatIf] [-Confirm] [<CommonParameters>]
- Export-Clixml [-Depth <Int32>] -LiteralPath <String> -InputObject <PSObject> [-Force]
  [-NoClobber] [-Encoding <Encoding>] [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -Depth System.Int32: ~
  -Encoding System.Text.Encoding:
    values:
    - ASCII
    - BigEndianUnicode
    - BigEndianUTF32
    - OEM
    - Unicode
    - UTF7
    - UTF8
    - UTF8BOM
    - UTF8NoBOM
    - UTF32
  -Force Switch: ~
  -InputObject System.Management.Automation.PSObject:
    required: true
  -LiteralPath,-PSPath,-LP System.String:
    required: true
  -NoClobber,-NoOverwrite Switch: ~
  -Path System.String:
    required: true
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
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
