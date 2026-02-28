description: Changes the file type association of a RemoteApp program in a Remote
  Desktop deployment
synopses:
- Set-RDFileTypeAssociation [-CollectionName] <String> -AppAlias <String> -FileExtension
  <String> -IsPublished <Boolean> [-IconPath <String>] [-IconIndex <String>] [-ConnectionBroker
  <String>] [<CommonParameters>]
- Set-RDFileTypeAssociation [-CollectionName] <String> -AppAlias <String> -FileExtension
  <String> -IsPublished <Boolean> [-IconPath <String>] [-IconIndex <String>] -VirtualDesktopName
  <String> [-ConnectionBroker <String>] [<CommonParameters>]
options:
  -AppAlias String:
    required: true
  -CollectionName String:
    required: true
  -ConnectionBroker String: ~
  -FileExtension String:
    required: true
  -IconIndex String: ~
  -IconPath String: ~
  -IsPublished Boolean:
    required: true
  -VirtualDesktopName,-VMName String:
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
