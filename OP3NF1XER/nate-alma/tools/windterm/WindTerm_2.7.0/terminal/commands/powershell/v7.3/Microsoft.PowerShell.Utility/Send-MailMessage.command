description: Sends an email message
synopses:
- Send-MailMessage [-Attachments <String[]>] [-Bcc <String[]>] [[-Body] <String>]
  [-BodyAsHtml] [-Encoding <Encoding>] [-Cc <String[]>] [-DeliveryNotificationOption
  <DeliveryNotificationOptions>] -From <String> [[-SmtpServer] <String>] [-Priority
  <MailPriority>] [-ReplyTo <String[]>] [[-Subject] <String>] [-To] <String[]> [-Credential
  <PSCredential>] [-UseSsl] [-Port <Int32>] [<CommonParameters>]
options:
  -Attachments,-PsPath System.String[]: ~
  -Bcc System.String[]: ~
  -Body System.String: ~
  -BodyAsHtml,-BAH Switch: ~
  -Cc System.String[]: ~
  -Credential System.Management.Automation.PSCredential: ~
  -DeliveryNotificationOption,-DNO System.Net.Mail.DeliveryNotificationOptions:
    values:
    - None
    - OnSuccess
    - OnFailure
    - Delay
    - Never
  -Encoding,-BE System.Text.Encoding:
    values:
    - ASCII
    - BigEndianUnicode
    - BigEndianUTF32
    - OEM
    - Unicode
    - UTF7
    - UTF8
    - UTF8BOM
    - UTF8NoBOM
    - UTF32
  -From System.String:
    required: true
  -Port System.Int32: ~
  -Priority System.Net.Mail.MailPriority:
    values:
    - Normal
    - High
    - Low
  -ReplyTo System.String[]: ~
  -SmtpServer,-ComputerName System.String: ~
  -Subject,-sub System.String: ~
  -To System.String[]:
    required: true
  -UseSsl Switch: ~
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
