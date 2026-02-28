description: Gets the properties and methods of objects
synopses:
- Get-Member [-InputObject <PSObject>] [[-Name] <String[]>] [-MemberType <PSMemberTypes>]
  [-View <PSMemberViewTypes>] [-Static] [-Force] [<CommonParameters>]
options:
  -Force Switch: ~
  -InputObject System.Management.Automation.PSObject: ~
  -MemberType,-Type System.Management.Automation.PSMemberTypes:
    values:
    - AliasProperty
    - CodeProperty
    - Property
    - NoteProperty
    - ScriptProperty
    - Properties
    - PropertySet
    - Method
    - CodeMethod
    - ScriptMethod
    - Methods
    - ParameterizedProperty
    - MemberSet
    - Event
    - Dynamic
    - All
  -Name System.String[]: ~
  -Static Switch: ~
  -View System.Management.Automation.PSMemberViewTypes:
    values:
    - Extended
    - Adapted
    - Base
    - All
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
