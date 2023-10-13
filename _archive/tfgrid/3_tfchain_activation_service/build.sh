set -ex
source conf.sh


#will start a docker, build, copy and then will shutdown because of the zinit shutdown
docker rm $NAME -f > /dev/null 2>&1 
echo " ** BUILDING  ******  for ${NAME}"
docker run --rm --name $NAME -v $HOME/myhost:/myhost -v $PWD/scripts:/scripts -v $PWD/zinit:/etc/zinit --env TFCHAIN_ACTIVATION_SERVICE_VERSION --hostname $NAME $BNAME
echo " ** BUILD DONE ****** for ${NAME}"