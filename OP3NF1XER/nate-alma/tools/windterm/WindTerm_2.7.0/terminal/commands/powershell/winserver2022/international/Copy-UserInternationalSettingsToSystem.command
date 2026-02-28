description: "Copies the current user's international settings (Windows Display language,\
  \ Input language, Regional Format/locale, and Location/GeoID) to one or both of\
  \ the following: * Welcome screen and system accounts * New user accounts  **Important:**\
  \ Note that this PowerShell cmdlet is only available for Windows 11 and later. \
  \ This is a system setting. It can only be changed by a user who has Administrator\
  \ permissions. Changes take effect after the computer is restarted"
synopses:
- Copy-UserInternationalSettingsToSystem [-WelcomeScreen <Boolean>] [-NewUser <Boolean>]
  [<CommonParameters>]
options:
  -WelcomeScreen Boolean:
    required: true
  -NewUser Boolean:
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
