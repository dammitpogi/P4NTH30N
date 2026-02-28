#!/usr/bin/env python3
"""Simple HTTP file server for Railway internal transfers"""

import http.server
import socketserver
import os
import json
from pathlib import Path

PORT = 8081
UPLOAD_DIR = "/shared-transfer"
os.makedirs(UPLOAD_DIR, exist_ok=True)


class FileHandler(http.server.SimpleHTTPRequestHandler):
    def do_PUT(self):
        """Handle file uploads"""
        path = self.path.lstrip("/")
        filepath = os.path.join(UPLOAD_DIR, path)
        os.makedirs(os.path.dirname(filepath), exist_ok=True)

        content_length = int(self.headers["Content-Length"])
        with open(filepath, "wb") as f:
            f.write(self.rfile.read(content_length))

        self.send_response(200)
        self.end_headers()
        self.wfile.write(f"Uploaded: {path}".encode())

    def do_GET(self):
        """Handle file downloads"""
        if self.path == "/":
            # List files
            files = []
            for root, dirs, filenames in os.walk(UPLOAD_DIR):
                for filename in filenames:
                    fullpath = os.path.join(root, filename)
                    relpath = os.path.relpath(fullpath, UPLOAD_DIR)
                    files.append({"path": relpath, "size": os.path.getsize(fullpath)})

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(files).encode())
        else:
            # Serve file
            filepath = os.path.join(UPLOAD_DIR, self.path.lstrip("/"))
            if os.path.exists(filepath):
                self.send_response(200)
                self.end_headers()
                with open(filepath, "rb") as f:
                    self.wfile.write(f.read())
            else:
                self.send_response(404)
                self.end_headers()


with socketserver.TCPServer(("0.0.0.0", PORT), FileHandler) as httpd:
    print(f"File server running on port {PORT}")
    print(f"Upload directory: {UPLOAD_DIR}")
    httpd.serve_forever()
