# SFTPGo + OpenClaw on Railway

This project runs:

- Public HTTPS (OpenClaw)
- Public SFTP (SFTPGo)
- Shared persistent storage

---

## Architecture

Railway Service
│
├── HTTPS → OpenClaw (port 8080)
├── TCP 2022 → SFTPGo
└── Volume mounted at /data

IMPORTANT:
Railway volumes can only attach to one service.
Both apps must run inside one container.

---

## Railway Deployment Steps

1. Create new Railway project
2. Deploy from GitHub (Dockerfile auto-detected)
3. Add Volume
   Mount path: /data

4. Configure Networking

HTTP:
- Railway auto-detects port 8080
- HTTPS automatically provided

TCP:
- Add TCP port
- Public: 2022
- Internal: 2022

---

## Connecting via SFTP

Host: yourapp.up.railway.app  
Port: 2022  
Protocol: SFTP  

## File Storage

All files stored in:

/data

Both SFTPGo and OpenClaw share this directory.

## Security Notes

- Use SSH keys instead of passwords
- Do not enable FTP
- Do not enable WebDAV
- Restrict users to home directories
- Rotate SSH host keys periodically
- Use strong passwords

## Custom Domain

1. Add domain in Railway
2. Set DNS CNAME
3. SSL auto-issued

## Production Notes

- Railway supports one HTTP port
- Railway supports additional TCP ports
- Volumes are single-attach only
- Single container required for shared storage
