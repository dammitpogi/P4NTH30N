description: Gets events from event logs and event tracing log files on local and
  remote computers
synopses:
- Get-WinEvent [[-LogName] <String[]>] [-MaxEvents <Int64>] [-ComputerName <String>]
  [-Credential <PSCredential>] [-FilterXPath <String>] [-Force] [-Oldest] [<CommonParameters>]
- Get-WinEvent [-ListLog] <String[]> [-ComputerName <String>] [-Credential <PSCredential>]
  [-Force] [<CommonParameters>]
- Get-WinEvent [-ListProvider] <String[]> [-ComputerName <String>] [-Credential <PSCredential>]
  [<CommonParameters>]
- Get-WinEvent [-ProviderName] <String[]> [-MaxEvents <Int64>] [-ComputerName <String>]
  [-Credential <PSCredential>] [-FilterXPath <String>] [-Force] [-Oldest] [<CommonParameters>]
- Get-WinEvent [-Path] <String[]> [-MaxEvents <Int64>] [-Credential <PSCredential>]
  [-FilterXPath <String>] [-Oldest] [<CommonParameters>]
- Get-WinEvent [-MaxEvents <Int64>] [-ComputerName <String>] [-Credential <PSCredential>]
  [-FilterHashtable] <Hashtable[]> [-Force] [-Oldest] [<CommonParameters>]
- Get-WinEvent [-MaxEvents <Int64>] [-ComputerName <String>] [-Credential <PSCredential>]
  [-FilterXml] <XmlDocument> [-Oldest] [<CommonParameters>]
options:
  -ComputerName,-Cn System.String: ~
  -Credential System.Management.Automation.PSCredential: ~
  -FilterHashtable System.Collections.Hashtable[]:
    required: true
  -FilterXml System.Xml.XmlDocument:
    required: true
  -FilterXPath System.String: ~
  -Force Switch: ~
  -ListLog System.String[]:
    required: true
  -ListProvider System.String[]:
    required: true
  -LogName System.String[]: ~
  -MaxEvents System.Int64: ~
  -Oldest Switch: ~
  -Path,-PSPath System.String[]:
    required: true
  -ProviderName System.String[]:
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
