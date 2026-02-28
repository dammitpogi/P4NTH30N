description: Converts .NET objects into HTML that can be displayed in a Web browser
synopses:
- ConvertTo-Html [-InputObject <PSObject>] [[-Property] <Object[]>] [[-Body] <String[]>]
  [[-Head] <String[]>] [[-Title] <String>] [-As <String>] [-CssUri <Uri>] [-PostContent
  <String[]>] [-PreContent <String[]>] [-Meta <Hashtable>] [-Charset <String>] [-Transitional]
  [<CommonParameters>]
- ConvertTo-Html [-InputObject <PSObject>] [[-Property] <Object[]>] [-As <String>]
  [-Fragment] [-PostContent <String[]>] [-PreContent <String[]>] [<CommonParameters>]
options:
  -As System.String:
    values:
    - Table
    - List
  -Body System.String[]: ~
  -Charset System.String: ~
  -CssUri,-cu,-uri System.Uri: ~
  -Fragment Switch: ~
  -Head System.String[]: ~
  -InputObject System.Management.Automation.PSObject: ~
  -Meta System.Collections.Hashtable: ~
  -PostContent System.String[]: ~
  -PreContent System.String[]: ~
  -Property System.Object[]: ~
  -Title System.String: ~
  -Transitional Switch: ~
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
