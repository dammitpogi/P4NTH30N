description: Updates the extended type data in the session
synopses:
- Update-TypeData [[-AppendPath] <String[]>] [-PrependPath <String[]>] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Update-TypeData [-MemberType <PSMemberTypes>] [-MemberName <String>] [-Value <Object>]
  [-SecondValue <Object>] [-TypeConverter <Type>] [-TypeAdapter <Type>] [-SerializationMethod
  <String>] [-TargetTypeForDeserialization <Type>] [-SerializationDepth <Int32>] [-DefaultDisplayProperty
  <String>] [-InheritPropertySerializationSet <Nullable`1>] [-StringSerializationSource
  <String>] [-DefaultDisplayPropertySet <String[]>] [-DefaultKeyPropertySet <String[]>]
  [-PropertySerializationSet <String[]>] -TypeName <String> [-Force] [-WhatIf] [-Confirm]
  [<CommonParameters>]
- Update-TypeData [-Force] [-TypeData] <TypeData[]> [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -AppendPath,-PSPath,-Path System.String[]: ~
  -DefaultDisplayProperty System.String: ~
  -DefaultDisplayPropertySet System.String[]: ~
  -DefaultKeyPropertySet System.String[]: ~
  -Force Switch: ~
  -InheritPropertySerializationSet System.Nullable`1[System.Boolean]: ~
  -MemberName System.String: ~
  -MemberType System.Management.Automation.PSMemberTypes:
    values:
    - NoteProperty
    - AliasProperty
    - ScriptProperty
    - CodeProperty
    - ScriptMethod
    - CodeMethod
  -PrependPath System.String[]: ~
  -PropertySerializationSet System.String[]: ~
  -SecondValue System.Object: ~
  -SerializationDepth System.Int32: ~
  -SerializationMethod System.String: ~
  -StringSerializationSource System.String: ~
  -TargetTypeForDeserialization System.Type: ~
  -TypeAdapter System.Type: ~
  -TypeConverter System.Type: ~
  -TypeData System.Management.Automation.Runspaces.TypeData[]:
    required: true
  -TypeName System.String:
    required: true
  -Value System.Object: ~
  -Confirm,-cf Switch: ~
  -WhatIf,-wi Switch: ~
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
