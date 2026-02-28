description: Adds items to and removes items from a property value that contains a
  collection of objects
synopses:
- Update-List [-Add <Object[]>] [-Remove <Object[]>] [-InputObject <PSObject>] [[-Property]
  <String>] [<CommonParameters>]
- Update-List -Replace <Object[]> [-InputObject <PSObject>] [[-Property] <String>]
  [<CommonParameters>]
options:
  -Add System.Object[]: ~
  -InputObject System.Management.Automation.PSObject: ~
  -Property System.String: ~
  -Remove System.Object[]: ~
  -Replace System.Object[]:
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
