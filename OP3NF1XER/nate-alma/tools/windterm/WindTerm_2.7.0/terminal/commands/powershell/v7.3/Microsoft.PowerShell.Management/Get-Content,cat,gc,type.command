description: Gets the content of the item at the specified location
synopses:
- Get-Content [-ReadCount <Int64>] [-TotalCount <Int64>] [-Tail <Int32>] [-Path] <String[]>
  [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>] [-Force] [-Credential
  <PSCredential>] [-Delimiter <String>] [-Wait] [-Raw] [-Encoding <Encoding>] [-AsByteStream]
  [-Stream <String>] [<CommonParameters>]
- Get-Content [-ReadCount <Int64>] [-TotalCount <Int64>] [-Tail <Int32>] -LiteralPath
  <String[]> [-Filter <String>] [-Include <String[]>] [-Exclude <String[]>] [-Force]
  [-Credential <PSCredential>] [-Delimiter <String>] [-Wait] [-Raw] [-Encoding <Encoding>]
  [-AsByteStream] [-Stream <String>] [<CommonParameters>]
options:
  -AsByteStream Switch: ~
  -Credential System.Management.Automation.PSCredential: ~
  -Delimiter System.String: ~
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
  -Filter System.String: ~
  -Force Switch: ~
  -Include System.String[]: ~
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Path System.String[]:
    required: true
  -Raw Switch: ~
  -ReadCount System.Int64: ~
  -Stream System.String: ~
  -Tail,-Last System.Int32: ~
  -TotalCount,-First,-Head System.Int64: ~
  -Wait Switch: ~
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
