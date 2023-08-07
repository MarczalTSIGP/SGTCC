#!/bin/sh
# https://gist.github.com/satendra02/1b335b06bfc5921df486f26bd98e0e89
set -e

if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
fi

# echo "Running database migrations..."
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:create db:migrate
# echo "Finished running database migrations."

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec bundle exec "$@"
