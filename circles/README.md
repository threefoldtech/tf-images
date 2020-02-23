# Threefold-Circles-Flist

	https://hub.grid.tf/mikhaieb/bishoyabdo-circles-latest.flist

- note server only work with https due to threebot login require this 

- you should set all below env variables when create the container and use the domain naming instead ip address in TAIGA_HOSTNAME as below 

- env variables are : SECRET_KEY , EMAIL_HOST, EMAIL_HOST_USER, EMAIL_HOST_PASSWORD, TAIGA_HOSTNAME, HTTP_PORT=80

- also you need configure restic env variables : RESTIC_REPOSITORY AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY RESTIC_PASSWORD"

- admin is create by default admin/123123 and to login admin account use https://staging.circles.threefold.me/admin/ 

```
container.py create -n 10.102.251.225 -iyocl 9Xk-WsnhkPi8c9 --clientsecret GjT \ 
-f https://hub.grid.tf/mikhaieb/bishoyabdo-circles-latest.flist \ 
-p '2222:22' -p '80:80' --name tiaga_test -envs SECRET_KEY=myscret -envs EMAIL_HOST=test@test.com \ 
-envs  RESTIC_REPOSITORY="s3:https://s3.grid.tf/taiga-test" -envs AWS_ACCESS_KEY_ID="myaccessid" \ 
-envs AWS_SECRET_ACCESS_KEY="myscret" -envs RESTIC_PASSWORD="mypass"

```


- create your ur https redirection in caddy server 

```

https://test.circles.com {
        proxy / 10.102.251.225:80 {
                transparent
        }
}

http://test.circles.com {
    redir https://test.circles.com{uri}
}

```
