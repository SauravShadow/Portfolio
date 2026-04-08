FROM python:3.12-slim

WORKDIR /app

# Copy all static portfolio files
COPY . .

# Expose the port the threaded server binds to
EXPOSE 8080

# Run the multithreaded HTTP server
CMD ["python", "start_server.py"]
