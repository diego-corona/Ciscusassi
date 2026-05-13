#!/bin/sh
set -e

echo "🔧 Esecuzione migrations..."
if [ ! -f "./data/database.sqlite" ]; then
    echo "📦 Primo avvio: esecuzione seed..."
    node dist/migrations.js --seed
else
    node dist/migrations.js
fi

echo "🚀 Avvio server..."
exec node dist/server.js
