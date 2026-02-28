description: Finds text in an XML string or document
synopses:
- Select-Xml [-XPath] <string> [-Xml] <XmlNode[]> [-Namespace <hashtable>] [<CommonParameters>]
- Select-Xml [-XPath] <string> [-Path] <string[]> [-Namespace <hashtable>] [<CommonParameters>]
- Select-Xml [-XPath] <string> -LiteralPath <string[]> [-Namespace <hashtable>] [<CommonParameters>]
- Select-Xml [-XPath] <string> -Content <string[]> [-Namespace <hashtable>] [<CommonParameters>]
options:
  -Content System.String[]:
    required: true
  -LiteralPath,-PSPath,-LP System.String[]:
    required: true
  -Namespace System.Collections.Hashtable: ~
  -Path System.String[]:
    required: true
  -Xml,-Node System.Xml.XmlNode[]:
    required: true
  -XPath System.String:
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
