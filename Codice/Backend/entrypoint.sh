#!/bin/sh
set -e

echo "🔧 Esecuzione migrations..."
node dist/migrations.js

echo "🚀 Avvio server..."
exec node dist/server.js
