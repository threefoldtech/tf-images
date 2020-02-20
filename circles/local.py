from .common import *
import os

MEDIA_URL = "http://localhost/media/"
STATIC_URL = "http://localhost/static/"
SITES["front"]["scheme"] = 'http'
SITES["front"]["domain"] = 'localhost'

DEBUG = False
PUBLIC_REGISTER_ENABLED = True

DEFAULT_FROM_EMAIL = "no-reply@example.com"
SERVER_EMAIL = DEFAULT_FROM_EMAIL

# CELERY_ENABLED = True

EVENTS_PUSH_BACKEND = "taiga.events.backends.rabbitmq.EventsPushBackend"
EVENTS_PUSH_BACKEND_OPTIONS = {"url": f"amqp://taiga:your_sceret_key@localhost:5672/taiga"}

# Uncomment and populate with proper connection parameters
# for enable email sending. EMAIL_HOST_USER should end by @domain.tld
EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"
EMAIL_USE_TLS = True
EMAIL_HOST = "smtp_email_host"
EMAIL_HOST_USER = "email_user"
EMAIL_HOST_PASSWORD = "email_password"
EMAIL_PORT = 587

# Uncomment and populate with proper connection parameters
# for enable github login/singin.
# GITHUB_API_CLIENT_ID = "yourgithubclientid"
# GITHUB_API_CLIENT_SECRET = "yourgithubclientsecret"
# threebot login parameters
PRIVATE_KEY = os.environ['PRIVATE_KEY']
THREEBOT_URL = os.environ['THREEBOT_URL']
OPEN_KYC_URL = os.environ['OPEN_KYC_URL']
