import http.server

PORT = 8080
DIRECTORY = "."

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
        
    def log_message(self, format, *args):
        pass
        
    def log_error(self, format, *args):
        pass

with http.server.ThreadingHTTPServer(("0.0.0.0", PORT), Handler) as httpd:
    httpd.serve_forever()
