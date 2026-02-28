description: Finds text in strings and files
synopses:
- Select-String [-Culture <String>] [-Pattern] <String[]> [-Path] <String[]> [-SimpleMatch]
  [-CaseSensitive] [-Quiet] [-List] [-NoEmphasis] [-Include <String[]>] [-Exclude
  <String[]>] [-NotMatch] [-AllMatches] [-Encoding <Encoding>] [-Context <Int32[]>]
  [<CommonParameters>]
- Select-String [-Culture <String>] -InputObject <PSObject> [-Pattern] <String[]>
  -Raw [-SimpleMatch] [-CaseSensitive] [-List] [-NoEmphasis] [-Include <String[]>]
  [-Exclude <String[]>] [-NotMatch] [-AllMatches] [-Encoding <Encoding>] [-Context
  <Int32[]>] [<CommonParameters>]
- Select-String [-Culture <String>] -InputObject <PSObject> [-Pattern] <String[]>
  [-SimpleMatch] [-CaseSensitive] [-Quiet] [-List] [-NoEmphasis] [-Include <String[]>]
  [-Exclude <String[]>] [-NotMatch] [-AllMatches] [-Encoding <Encoding>] [-Context
  <Int32[]>] [<CommonParameters>]
- Select-String [-Culture <String>] [-Pattern] <String[]> [-Path] <String[]> -Raw
  [-SimpleMatch] [-CaseSensitive] [-List] [-NoEmphasis] [-Include <String[]>] [-Exclude
  <String[]>] [-NotMatch] [-AllMatches] [-Encoding <Encoding>] [-Context <Int32[]>]
  [<CommonParameters>]
- Select-String [-Culture <String>] [-Pattern] <String[]> -LiteralPath <String[]>
  -Raw [-SimpleMatch] [-CaseSensitive] [-List] [-NoEmphasis] [-Include <String[]>]
  [-Exclude <String[]>] [-NotMatch] [-AllMatches] [-Encoding <Encoding>] [-Context
  <Int32[]>] [<CommonParameters>]
- Select-String [-Culture <String>] [-Pattern] <String[]> -LiteralPath <String[]>
  [-SimpleMatch] [-CaseSensitive] [-Quiet] [-List] [-NoEmphasis] [-Include <String[]>]
  [-Exclude <String[]>] [-NotMatch] [-AllMatches] [-Encoding <Encoding>] [-Context
  <Int32[]>] [<CommonParameters>]
options:
  -AllMatches Switch: ~
  -CaseSensitive Switch: ~
  -Context System.Int32[]: ~
  -Culture System.String: ~
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
  -Exclude System.String[]: ~
  -Include System.String[]: ~
  -InputObject System.Management.Automation.PSObject:
    required: true
  -List Switch: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -NoEmphasis Switch: ~
  -NotMatch Switch: ~
  -Path System.String[]:
    required: true
  -Pattern System.String[]:
    required: true
  -Quiet Switch: ~
  -Raw Switch:
    required: true
  -SimpleMatch Switch: ~
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
