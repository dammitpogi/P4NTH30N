#!/bin/bash
cd /c/P4NTH30N/OP3NF1XER/nate-alma/dev
tar -czf /tmp/dev-archive.tar.gz --exclude='node_modules' --exclude='.git' --exclude='tmp-*' .
cat /tmp/dev-archive.tar.gz | railway ssh "cd /data/workspace && tar -xzf - && echo 'Transfer complete' && ls -la"
