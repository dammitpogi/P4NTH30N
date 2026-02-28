description: Starts a virtual process
synopses:
- Start-AppvVirtualProcess [-FilePath] <String> [[-ArgumentList] <String[]>] [-Credential
  <PSCredential>] [-WorkingDirectory <String>] [-LoadUserProfile] [-NoNewWindow] [-PassThru]
  [-RedirectStandardError <String>] [-RedirectStandardInput <String>] [-RedirectStandardOutput
  <String>] [-Wait] [-UseNewEnvironment] -AppvClientObject <Object> [<CommonParameters>]
- Start-AppvVirtualProcess [-FilePath] <String> [[-ArgumentList] <String[]>] [-WorkingDirectory
  <String>] [-PassThru] [-Verb <String>] [-Wait] [-WindowStyle <ProcessWindowStyle>]
  -AppvClientObject <Object> [<CommonParameters>]
options:
  -AppvClientObject Object:
    required: true
  -ArgumentList,-Args String[]: ~
  -Credential,-RunAs PSCredential: ~
  -FilePath,-PSPath String:
    required: true
  -LoadUserProfile,-Lup Switch: ~
  -NoNewWindow,-nnw Switch: ~
  -PassThru Switch: ~
  -RedirectStandardError,-RSE String: ~
  -RedirectStandardInput,-RSI String: ~
  -RedirectStandardOutput,-RSO String: ~
  -UseNewEnvironment Switch: ~
  -Verb String: ~
  -Wait Switch: ~
  -WindowStyle ProcessWindowStyle:
    values:
    - Normal
    - Hidden
    - Minimized
    - Maximized
  -WorkingDirectory String: ~
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
