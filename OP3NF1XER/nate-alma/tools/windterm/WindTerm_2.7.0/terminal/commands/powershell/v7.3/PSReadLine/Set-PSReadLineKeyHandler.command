description: Binds keys to user-defined or PSReadLine key handler functions
synopses:
- Set-PSReadLineKeyHandler [-ScriptBlock] <ScriptBlock> [-BriefDescription <String>]
  [-Description <String>] [-Chord] <String[]> [-ViMode <ViMode>] [<CommonParameters>]
- Set-PSReadLineKeyHandler [-Chord] <String[]> [-ViMode <ViMode>] [-Function] <String>
  [<CommonParameters>]
options:
  -BriefDescription System.String: ~
  -Chord,-Key System.String[]:
    required: true
  -Description,-LongDescription System.String: ~
  -Function System.String:
    required: true
  -ScriptBlock System.Management.Automation.ScriptBlock:
    required: true
  -ViMode Microsoft.PowerShell.ViMode: ~
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
