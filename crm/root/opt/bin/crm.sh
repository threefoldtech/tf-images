echo **START**;cd /opt/code/github/incubaid/crm;export SQLALCHEMY_DATABASE_URI=postgresql://postgres:postgres@localhost:5432/crm;export ENV=prod;export FLASK_APP=app.py;export  CACHE_BACKEND_URI=redis://127.0.0.1:6379/0;flask db upgrade;uwsgi --ini uwsgi.ini && echo **OK** || echo **ERROR**