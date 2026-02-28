description: Starts one or more processes on the local computer
synopses:
- Start-Process [-FilePath] <String> [[-ArgumentList] <String[]>] [-Credential <PSCredential>]
  [-WorkingDirectory <String>] [-LoadUserProfile] [-NoNewWindow] [-PassThru] [-RedirectStandardError
  <String>] [-RedirectStandardInput <String>] [-RedirectStandardOutput <String>] [-WindowStyle
  <ProcessWindowStyle>] [-Wait] [-UseNewEnvironment] [-WhatIf] [-Confirm] [<CommonParameters>]
- Start-Process [-FilePath] <String> [[-ArgumentList] <String[]>] [-WorkingDirectory
  <String>] [-PassThru] [-Verb <String>] [-WindowStyle <ProcessWindowStyle>] [-Wait]
  [-WhatIf] [-Confirm] [<CommonParameters>]
options:
  -ArgumentList,-Args System.String[]: ~
  -Credential,-RunAs System.Management.Automation.PSCredential: ~
  -FilePath,-PSPath,-Path System.String:
    required: true
  -LoadUserProfile,-Lup Switch: ~
  -NoNewWindow,-nnw Switch: ~
  -PassThru Switch: ~
  -RedirectStandardError,-RSE System.String: ~
  -RedirectStandardInput,-RSI System.String: ~
  -RedirectStandardOutput,-RSO System.String: ~
  -UseNewEnvironment Switch: ~
  -Verb System.String: ~
  -Wait Switch: ~
  -WindowStyle System.Diagnostics.ProcessWindowStyle:
    values:
    - Normal
    - Hidden
    - Minimized
    - Maximized
  -WorkingDirectory System.String: ~
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
