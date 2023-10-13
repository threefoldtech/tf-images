mkdir -p ~/myhost
ssh-add -L > ~/myhost/authorized_keys
SSH_PORT=5001
SSH_TRAILS=10

docker rm builder_python -f
docker run -d --name builder_python -it -v $HOME/myhost:/myhost \
    -p $SSH_PORT:22 \
    --hostname python \
    builders_python

ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:$SSH_PORT"
sleep 2

if [ "$1" ]; then
    exit 0
else
    echo "trying connecting over ssh..."
    for i in $(seq 1 $SSH_TRAILS);  do
        ssh -A -o "StrictHostKeyChecking=no" root@localhost -p $SSH_PORT && break || echo "connection failed, trying again..."
        sleep 0.5
    done
fi
