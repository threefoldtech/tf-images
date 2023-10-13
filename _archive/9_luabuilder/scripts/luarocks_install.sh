set -ex

echo https://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
apk update

apk add --no-cache gcc make lua-dev musl-dev zip openssl openssl-dev bsd-compat-headers tmux
apk add --no-cache lua-sec lua-jsonschema lua-lanes lua-date lua-filesystem lua-lapis lua-sql-sqlite3 lua-socket
apk add --no-cache lua-penlight lua-sleep lua-dns lua-cliargs lua-rapidjson lua-inspect lua-curl lua-linotify
apk add --no-cache lua-toml lua-redis lua-etlua lua-lunix lua-cqueues lua-uuid lua-cjson
cd /tmp

wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz
tar zxpf luarocks-3.8.0.tar.gz
cd luarocks-3.8.0
./configure
make
make install

luarocks install sleep


#https://github.com/hoelzro/linotify
#https://github.com/wahern/lunix