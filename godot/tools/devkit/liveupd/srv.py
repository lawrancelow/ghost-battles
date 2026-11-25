#!/usr/bin/env python3
# 測試用更新伺服器：限速、支援 Range 續傳、可以第一次落到一半就斷線
# python3 srv.py <dir> <port> <bytes_per_sec> [drop_at_bytes]
import http.server, os, sys, time, json

D, PORT, BPS = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
DROP = int(sys.argv[4]) if len(sys.argv) > 4 else 0
state = {"dropped": False}

class H(http.server.BaseHTTPRequestHandler):
    def log_message(self, *a):
        sys.stderr.write("[srv] " + (a[0] % a[1:]) + " range=" + str(self.headers.get("Range")) + "\n")

    def do_GET(self):
        p = os.path.join(D, self.path.split("?")[0].lstrip("/"))
        if not os.path.isfile(p):
            self.send_response(404); self.end_headers(); return
        size = os.path.getsize(p); start = 0
        rg = self.headers.get("Range")
        if rg and rg.startswith("bytes="):
            start = int(rg[6:].split("-")[0])
            self.send_response(206)
            self.send_header("Content-Range", "bytes %d-%d/%d" % (start, size - 1, size))
        else:
            self.send_response(200)
        self.send_header("Content-Length", str(size - start))
        self.end_headers()
        with open(p, "rb") as f:
            f.seek(start); sent = start; t0 = time.time(); n0 = 0
            while True:
                b = f.read(65536)
                if not b: break
                if DROP and not state["dropped"] and sent + len(b) > DROP and p.endswith(".pck"):
                    state["dropped"] = True
                    self.wfile.write(b[:max(0, DROP - sent)]); self.wfile.flush()
                    self.connection.close(); return
                self.wfile.write(b); sent += len(b); n0 += len(b)
                if p.endswith(".pck") and BPS > 0:
                    lag = n0 / BPS - (time.time() - t0)
                    if lag > 0: time.sleep(lag)

http.server.ThreadingHTTPServer(("127.0.0.1", PORT), H).serve_forever()
