echo **START**;ulimit -n 8192; /opt/bin/caddy -conf=/opt/cfg/caddy.cfg  -agree && echo **OK** || echo **ERROR**
