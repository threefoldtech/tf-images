set -ex
source conf.sh

echo " ** BUILD"

echo " ** BUILD START ****** for ${BNAME}"
docker build . -t ${BNAME}
echo " ** BUILD OK ****** for ${BNAME}"

#will start a docker, build tfchain and then will shutdown because of the zinit shutdown
docker rm $NAME -f > /dev/null 2>&1 
echo " ** BUILD POST INSTALL ****** for ${BNAME}"
docker run --rm --name $NAME -v $HOME/myhost:/myhost -v $PWD/scripts:/scripts -v $PWD/zinit:/etc/zinit --env TFCHAIN_VERSION --hostname $NAME $BNAME
echo " ** BUILD POST INSTALL DONE ****** for ${BNAME}"