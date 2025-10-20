import os
import sys
myPath = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, myPath)
from settings import *

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DB_NAME','app'),
        'USER': os.environ.get('DB_USER','app'),
        'PASSWORD': os.environ.get('DB_PASSWORD','app'),
        'HOST': os.environ.get('DB_HOST', 'db'),
        'PORT': os.environ.get('DB_PORT', '5432')
    }
}

STATIC_URL = 'static/'
STATIC_ROOT = "static"

ALLOWED_HOSTS.append('*')
