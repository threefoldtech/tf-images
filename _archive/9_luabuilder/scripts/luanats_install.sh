set -ex


# tarantoolctl rocks install lua-sec
# luarocks make rockspec/nats-0.0.3-1.rockspec
# luarocks install --server=http://luarocks.org/dev http
# luarocks install lua-cjson
# luarocks install luasocket
# luarocks install uuid

cd /tmp
git clone https://github.com/dawnangel/lua-nats
cd lua-nats
luarocks make rockspec/nats-0.0.3-1.rockspec

