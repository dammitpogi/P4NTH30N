description: Customizes the behavior of command line editing in **PSReadLine**
synopses:
- Set-PSReadLineOption [-EditMode <EditMode>] [-ContinuationPrompt <String>] [-HistoryNoDuplicates]
  [-AddToHistoryHandler <System.Func`2[System.String,System.Object]>] [-CommandValidationHandler
  <System.Action`1[System.Management.Automation.Language.CommandAst]>] [-HistorySearchCursorMovesToEnd]
  [-MaximumHistoryCount <Int32>] [-MaximumKillRingCount <Int32>] [-ShowToolTips] [-ExtraPromptLineCount
  <Int32>] [-DingTone <Int32>] [-DingDuration <Int32>] [-BellStyle <BellStyle>] [-CompletionQueryItems
  <Int32>] [-WordDelimiters <String>] [-HistorySearchCaseSensitive] [-HistorySaveStyle
  <HistorySaveStyle>] [-HistorySavePath <String>] [-AnsiEscapeTimeout <Int32>] [-PromptText
  <String[]>] [-ViModeIndicator <ViModeStyle>] [-ViModeChangeHandler <ScriptBlock>]
  [-PredictionSource <PredictionSource>] [-PredictionViewStyle <PredictionViewStyle>]
  [-Colors <Hashtable>] [<CommonParameters>]
options:
  -AddToHistoryHandler System.Func`2[System.String,System.Object]: ~
  -AnsiEscapeTimeout System.Int32: ~
  -BellStyle Microsoft.PowerShell.BellStyle: ~
  -Colors System.Collections.Hashtable: ~
  -CommandValidationHandler System.Action`1[System.Management.Automation.Language.CommandAst]: ~
  -CompletionQueryItems System.Int32: ~
  -ContinuationPrompt System.String: ~
  -DingDuration System.Int32: ~
  -DingTone System.Int32: ~
  -EditMode Microsoft.PowerShell.EditMode: ~
  -ExtraPromptLineCount System.Int32: ~
  -HistoryNoDuplicates Switch: ~
  -HistorySavePath System.String: ~
  -HistorySaveStyle Microsoft.PowerShell.HistorySaveStyle: ~
  -HistorySearchCaseSensitive Switch: ~
  -HistorySearchCursorMovesToEnd Switch: ~
  -MaximumHistoryCount System.Int32: ~
  -MaximumKillRingCount System.Int32: ~
  -PredictionSource Microsoft.PowerShell.PredictionSource: ~
  -PredictionViewStyle Microsoft.PowerShell.PredictionViewStyle: ~
  -PromptText System.String[]: ~
  -ShowToolTips Switch: ~
  -ViModeChangeHandler System.Management.Automation.ScriptBlock: ~
  -ViModeIndicator Microsoft.PowerShell.ViModeStyle: ~
  -WordDelimiters System.String: ~
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
