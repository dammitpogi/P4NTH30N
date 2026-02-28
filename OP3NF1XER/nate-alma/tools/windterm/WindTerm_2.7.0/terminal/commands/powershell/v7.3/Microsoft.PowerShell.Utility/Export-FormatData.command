description: Saves formatting data from the current session in a formatting file
synopses:
- Export-FormatData -InputObject <ExtendedTypeDefinition[]> -Path <String> [-Force]
  [-NoClobber] [-IncludeScriptBlock] [<CommonParameters>]
- Export-FormatData -InputObject <ExtendedTypeDefinition[]> -LiteralPath <String>
  [-Force] [-NoClobber] [-IncludeScriptBlock] [<CommonParameters>]
options:
  -Force Switch: ~
  -IncludeScriptBlock Switch: ~
  -InputObject System.Management.Automation.ExtendedTypeDefinition[]:
    required: true
  -LiteralPath,-PSPath,-LP System.String:
    required: true
  -NoClobber,-NoOverwrite Switch: ~
  -Path,-FilePath System.String:
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
