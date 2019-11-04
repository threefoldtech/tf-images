# Install dependencies and populate database
cd /taiga/taiga-back
/taiga/taiga-back/taiga/bin/pip3 install -r requirements.txt
/taiga/taiga-back/taiga/bin/python3 manage.py migrate --noinput
/taiga/taiga-back/taiga/bin/python3 manage.py loaddata initial_user
/taiga/taiga-back/taiga/bin/python3 manage.py loaddata initial_project_templates
/taiga/taiga-back/taiga/bin/python3 manage.py compilemessages
/taiga/taiga-back/taiga/bin/python3 manage.py collectstatic --noinput