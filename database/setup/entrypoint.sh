#!/bin/bash
# Custom entrypoint script for MSSQL container to run initialization scripts

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to start (60 seconds max)
echo "Waiting for SQL Server to start..."
for i in {1..60}; do
    if /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "${SA_PASSWORD}" -C -Q "SELECT 1" &> /dev/null; then
        echo "SQL Server started successfully"
        break
    fi
    echo "Attempt $i: SQL Server not ready yet..."
    sleep 1
done

# Run initialization scripts
echo "Running database initialization scripts..."
for script in /docker-entrypoint-initdb.d/*.sql; do
    if [ -f "$script" ]; then
        echo "Executing: $script"
        /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "${SA_PASSWORD}" -C -i "$script"
        if [ $? -eq 0 ]; then
            echo "Successfully executed: $script"
        else
            echo "Error executing: $script"
        fi
    fi
done

echo "Database initialization completed"

# Keep SQL Server running in foreground
wait
