description: Returns the specified part of a path
synopses:
- Split-Path [-Path] <String[]> [-Parent] [-Resolve] [-Credential <PSCredential>]
  [<CommonParameters>]
- Split-Path [-Path] <String[]> -Leaf [-Resolve] [-Credential <PSCredential>] [<CommonParameters>]
- Split-Path [-Path] <String[]> -LeafBase [-Resolve] [-Credential <PSCredential>]
  [<CommonParameters>]
- Split-Path [-Path] <String[]> -Extension [-Resolve] [-Credential <PSCredential>]
  [<CommonParameters>]
- Split-Path [-Path] <String[]> -Qualifier [-Resolve] [-Credential <PSCredential>]
  [<CommonParameters>]
- Split-Path [-Path] <String[]> -NoQualifier [-Resolve] [-Credential <PSCredential>]
  [<CommonParameters>]
- Split-Path [-Path] <String[]> [-Resolve] -IsAbsolute [-Credential <PSCredential>]
  [<CommonParameters>]
- Split-Path -LiteralPath <String[]> [-Resolve] [-Credential <PSCredential>] [<CommonParameters>]
options:
  -Credential System.Management.Automation.PSCredential: ~
  -Extension Switch:
    required: true
  -IsAbsolute Switch:
    required: true
  -Leaf Switch:
    required: true
  -LeafBase Switch:
    required: true
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -NoQualifier Switch:
    required: true
  -Parent Switch: ~
  -Path System.String[]:
    required: true
  -Qualifier Switch:
    required: true
  -Resolve Switch: ~
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
