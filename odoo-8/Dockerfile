FROM debian:jessie

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            node-less \
            node-clean-css \
            python-pyinotify \
            python-renderpm \
            python-support \
            wkhtmltopdf \
            python-pip \
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# install supervisord
# start supervisor
RUN apt-get install  python-pip -y
RUN pip install supervisor

# Copy supervisor config to supervisor configuration
COPY supervisor.conf /etc/supervisor/supervisord.conf
RUN mkdir -p /var/log/postgres
RUN mkdir -p /var/log/odoo

# install postgres

#RUN apt-get update && apt-get install -y postgresql

RUN apt-get update && apt-get install -y postgresql-common postgresql-9.4 postgresql-client-9.4 postgresql-client-common openssh-server

RUN mkdir -p /var/log/postgresql

# Install Odoo dependenices
RUN apt install python-babel python-dateutil python-decorator python-docutils python-feedparser python-imaging python-jinja2 python-ldap python-libxslt1 python-lxml python-mako python-mock python-openid python-passlib python-psutil python-psycopg2 python-pychart python-pydot  python-pyparsing python-pypdf python-reportlab  python-simplejson  python-unittest2 python-vatnumber python-vobject python-werkzeug python-xlwt python-yaml  -y
# Install Odoo
ENV ODOO_VERSION 8.0
ENV ODOO_RELEASE latest
RUN set -x; \
        curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
        && echo 'c41c6eaf93015234b4b62125436856a482720c3d odoo.deb' | sha1sum -c - \
        && dpkg --force-depends -i odoo.deb \
        && apt-get update \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf /var/lib/apt/lists/* odoo.deb

# INSTALL ssh server
RUN  apt install openssh-server -y

# Copy entrypoint script and Odoo configuration file
COPY ./start_odoo.sh /
COPY ./openerp-server.conf /etc/odoo/
RUN chown odoo /etc/odoo/openerp-server.conf

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN mkdir -p /mnt/extra-addons \
        && chown -R odoo /mnt/extra-addons /opt/odoo
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]
RUN chmod +x /start_odoo.sh
# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV OPENERP_SERVER /etc/odoo/openerp-server.conf

# crontab backup restic
RUN mkdir /etc/templates
RUN mkdir /backup
COPY backup-template /etc/templates/backup-template
COPY DB-backup.py /root/

ENTRYPOINT ["/start_odoo.sh"]

# Set default user when running the container
#USER odoo

