import os

# Явные импорты необходимых переменных из базовых настроек
from django_project.settings import (
    ALLOWED_HOSTS,
)

# Переопределение базовых настроек для продакшн
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.environ.get("DB_NAME", "app"),
        "USER": os.environ.get("DB_USER", "app"),
        "PASSWORD": os.environ.get("DB_PASSWORD", "app"),
        "HOST": os.environ.get("DB_HOST", "db"),
        "PORT": os.environ.get("DB_PORT", "5432"),
    }
}


# Добавляем "*" в ALLOWED_HOSTS
ALLOWED_HOSTS.append("*")
