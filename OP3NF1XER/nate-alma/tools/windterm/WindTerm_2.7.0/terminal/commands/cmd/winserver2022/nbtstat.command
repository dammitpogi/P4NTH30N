description:
  Displays NetBIOS over TCP/IP (NetBT) protocol statistics, NetBIOS name tables for both the local computer and remote computers, and the NetBIOS name cache.
synopses:
  - nbtstat [/a <remotename>] [/A <IPaddress>] [/c] [/n] [/r] [/R] [/RR] [/s] [/S] [<interval>]
options:
  /a <remotename>: Displays the NetBIOS name table of a remote computer, where remotename is the NetBIOS computer name of the remote computer.
  /A <IPaddress>: Displays the NetBIOS name table of a remote computer, specified by the IP address (in dotted decimal notation) of the remote computer.
  /c: Displays the contents of the NetBIOS name cache, the table of NetBIOS names and their resolved IP addresses.
  /n: Displays the NetBIOS name table of the local computer.
  /r: Displays NetBIOS name resolution statistics.
  /R: Purges the contents of the NetBIOS name cache and then reloads the pre-tagged entries from the Lmhosts file.
  /RR: Releases and then refreshes NetBIOS names for the local computer that is registered with WINS servers.
  /s: Displays NetBIOS client and server sessions, attempting to convert the destination IP address to a name.
  /S: Displays NetBIOS client and server sessions, listing the remote computers by destination IP address only.s CTRL+C to stop displaying statistics. If this parameter is omitted, nbtstat prints the current configuration information only once.
  /?: Displays help at the command prompt.
