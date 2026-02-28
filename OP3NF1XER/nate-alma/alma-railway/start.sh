#!/bin/sh

echo "Starting services..."
exec /usr/bin/supervisord -c /etc/supervisord.conf
