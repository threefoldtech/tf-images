. args.sh

docker rm builder_$NAME -f 2>&1 >> /dev/null
docker rmi builder_$NAME -f 2>&1 >> /dev/null