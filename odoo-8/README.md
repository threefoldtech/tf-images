# odoo-8-docker
```buildoutcfg
docker build -t threefolddev/odoo-8:latest .
docker run -dit -p8070:8069 --name odoo -v /opt/odoo-staging/addons:/opt/odoo/custom/addons -v /opt/odoo-staging/postgresql:/var/lib/postgresql  threefolddev/odoo-8:latest 

```

- you need to move your addons on path /opt/odoo-staging/addons
- default access is admin/admin, you need to change it when login first time
- our threefold old addons was on paths ```/opt/odoo/odoo-server/addons ``` , ``` /opt/odoo/custom/addons ```


## Restore old one

1. find  tables to remove
```buildoutcfg
root@tfwallet-prod:~# docker exec -it  odoo bash
root@ec9762e6511d:~# su - postgres
postgres@ec9762e6511d:~$ psql odoo
psql (9.4.26)
Type "help" for help.

odoo=# 

SELECT
    'drop table if exists "' || tablename || '" cascade;' as pg_drop
FROM
    pg_tables
WHERE
    schemaname='public';


```
2. Drop tables as got from above
3. restore database on odoo containeer
```buildoutcfg
root@ec9762e6511d:~# su - postgres
psql -d odoo -f .odoo_dump.sql
```
4. make sure to copy all addons from old one ( paths ```/opt/odoo/odoo-server/addons ``` , ``` /opt/odoo/custom/addons ``` )  to new container on path /opt/odoo/custom/addons

5. restart container or supervisor services

```
docker restart odoo
```
