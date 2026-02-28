description: Adds custom properties and methods to an instance of a PowerShell object
synopses:
- Add-Member -InputObject <PSObject> -TypeName <String> [-PassThru] [<CommonParameters>]
- Add-Member -InputObject <PSObject> [-TypeName <String>] [-Force] [-PassThru] [-NotePropertyMembers]
  <IDictionary> [<CommonParameters>]
- Add-Member -InputObject <PSObject> [-TypeName <String>] [-Force] [-PassThru] [-NotePropertyName]
  <String> [-NotePropertyValue] <Object> [<CommonParameters>]
- Add-Member -InputObject <PSObject> [-MemberType] <PSMemberTypes> [-Name] <String>
  [[-Value] <Object>] [[-SecondValue] <Object>] [-TypeName <String>] [-Force] [-PassThru]
  [<CommonParameters>]
options:
  -Force Switch: ~
  -InputObject System.Management.Automation.PSObject:
    required: true
  -MemberType,-Type System.Management.Automation.PSMemberTypes:
    required: true
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
  -Name System.String:
    required: true
  -NotePropertyMembers System.Collections.IDictionary:
    required: true
  -NotePropertyName System.String:
    required: true
  -NotePropertyValue System.Object:
    required: true
  -PassThru Switch: ~
  -SecondValue System.Object: ~
  -TypeName System.String: ~
  -Value System.Object: ~
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
