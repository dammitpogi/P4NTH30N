description: Creates a custom FOD repository that includes packages that support the
  installation of the specified capabilities. See [FOD repositories](/windows-hardware/manufacture/desktop/features-on-demand-v2--capabilities#fod-repositories)
  for more information
synopses:
- Export-WindowsCapabilitySource [-Name <String>] -Source <String> -Target <String>
  -Path <String> [-WindowsDirectory <String>] [-SystemDrive <String>] [-LogPath <String>]
  [-ScratchDirectory <String>] [-LogLevel <LogLevel>] [<CommonParameters>]
options:
  -LogLevel,-LL LogLevel:
    values:
    - Errors
    - Warnings
    - WarningsInfo
    - Debug
  -LogPath,-LP String: ~
  -Name String: ~
  -Path String:
    required: true
  -ScratchDirectory String: ~
  -Source String:
    required: true
  -SystemDrive String: ~
  -Target String:
    required: true
  -WindowsDirectory String: ~
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
