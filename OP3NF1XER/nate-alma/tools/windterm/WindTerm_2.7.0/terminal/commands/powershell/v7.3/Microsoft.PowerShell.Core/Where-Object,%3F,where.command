description: Selects objects from a collection based on their property values
synopses:
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  [-EQ] [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-FilterScript] <ScriptBlock> [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -Match [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CEQ [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -NE [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CNE [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -GT [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CGT [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -LT [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CLT [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -GE [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CGE [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -LE [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CLE [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -Like [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CLike [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -NotLike [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CNotLike [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CMatch [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -NotMatch [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CNotMatch [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -Contains [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CContains [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -NotContains [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CNotContains [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -In [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CIn [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -NotIn [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -CNotIn [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -Is [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> [[-Value] <Object>]
  -IsNot [<CommonParameters>]
- Where-Object [-InputObject <PSObject>] [-Property] <String> -Not [<CommonParameters>]
options:
  -CContains Switch:
    required: true
  -CEQ Switch:
    required: true
  -CGE Switch:
    required: true
  -CGT Switch:
    required: true
  -CIn Switch:
    required: true
  -CLE Switch:
    required: true
  -CLike Switch:
    required: true
  -CLT Switch:
    required: true
  -CMatch Switch:
    required: true
  -CNE Switch:
    required: true
  -CNotContains Switch:
    required: true
  -CNotIn Switch:
    required: true
  -CNotLike Switch:
    required: true
  -CNotMatch Switch:
    required: true
  -Contains,-IContains Switch:
    required: true
  -EQ,-IEQ Switch: ~
  -FilterScript System.Management.Automation.ScriptBlock:
    required: true
  -GE,-IGE Switch:
    required: true
  -GT,-IGT Switch:
    required: true
  -In,-IIn Switch:
    required: true
  -InputObject System.Management.Automation.PSObject: ~
  -Is Switch:
    required: true
  -IsNot Switch:
    required: true
  -LE,-ILE Switch:
    required: true
  -Like,-ILike Switch:
    required: true
  -LT,-ILT Switch:
    required: true
  -Match,-IMatch Switch:
    required: true
  -NE,-INE Switch:
    required: true
  -Not Switch:
    required: true
  -NotContains,-INotContains Switch:
    required: true
  -NotIn,-INotIn Switch:
    required: true
  -NotLike,-INotLike Switch:
    required: true
  -NotMatch,-INotMatch Switch:
    required: true
  -Property System.String:
    required: true
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
