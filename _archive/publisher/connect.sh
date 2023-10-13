. args.sh
# ssh-add -L > ~/myhost/authorized_keys
docker rm builder_$NAME -f 2>&1 >> /dev/null
docker run -d --name builder_$NAME -it -v $HOME/myhost:/myhost \
    -p 5023:22 \
    --hostname $NAME \
    builder_$NAME

    # -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \

#UGLY HACK to remove know hosts file 
# rm -f ~/.ssh/known_hosts
# sleep 0.6

# if [ "$1" ]; then
#     exit 0
# else
#     ssh -A -o "StrictHostKeyChecking=no" root@localhost -p 5023
# fi
