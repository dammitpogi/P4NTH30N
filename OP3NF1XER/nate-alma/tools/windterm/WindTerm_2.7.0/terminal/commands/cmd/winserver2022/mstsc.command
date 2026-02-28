description:
  Manage connections to Remote Desktop Session Host servers or other remote computers.
synopses:
  - mstsc [<connectionfile>] [/v:<server>[:<port>]] [/admin] [/f] [/w:<width> /h:<height>]
    [/public] [/span]
  - mstsc /edit <connectionfile>
  - mstsc /migrate
options:
  /v:<server>[:<port>]: Specifies the remote computer and, optionally, the port number to which you want to connect.
  /admin: Connects you to a session for administering the server.
  /f: Starts Remote Desktop Connection in full-screen mode.
  /w:<width>: Specifies the width of the Remote Desktop window.
  /h:<height>: Specifies the height of the Remote Desktop window.
  /public: Runs Remote Desktop in public mode. In public mode, passwords and bitmaps aren't cached.
  /span: Matches the Remote Desktop width and height with the local virtual desktop, spanning across multiple monitors if necessary.
  /edit <connectionfile>: Opens the specified .rdp file for editing.
  /migrate: Migrates legacy connection files that were created with Client Connection Manager to new .rdp connection files.
  /?: Displays help at the command prompt.