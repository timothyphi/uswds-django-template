"""
Django settings for django_project project.

For more information on this file, see
https://docs.djangoproject.com/en/5.0/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/5.0/ref/settings/
"""

import os
from datetime import timedelta, timezone
from pathlib import Path
from tomllib import load as load_toml_config


def create_directory(folderpath: Path) -> None:
    """Creates a directory if it doesn't already exist"""
    os.makedirs(folderpath, exist_ok=True)


# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent.parent
ENV_FILE = BASE_DIR / ".env.toml"
with open(ENV_FILE, "rb") as f:
    ENV_DATA = load_toml_config(f)

MODE = ENV_DATA["MODE"]
ENV_DATA = ENV_DATA[MODE]  # type: ignore
CONFIG_PORT = ENV_DATA["PORT"]
CONFIG_HOST = ENV_DATA["HOST"]

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = ENV_DATA["SECRET_KEY"]

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False if MODE == "prod" else True

ALLOWED_HOSTS = ENV_DATA["ALLOWED_HOSTS"]


################################################################################
# Application definition
################################################################################


INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "django_project.urls"

TEMPLATES = [  # type: ignore
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "templates"],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "django_project.wsgi.application"


################################################################################
# Database
# https://docs.djangoproject.com/en/5.0/ref/settings/#databases
################################################################################


DB_HOST = ENV_DATA["DB_HOST"]
DB_PORT = ENV_DATA["DB_PORT"]
DB_NAME = ENV_DATA["DB_NAME"]
DB_USER = ENV_DATA["DB_USER"]
DB_PASS = ENV_DATA["DB_PASS"]

DATABASES = {  # type: ignore
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": BASE_DIR / "db.sqlite3",
    }
}


################################################################################
# Password validation
# https://docs.djangoproject.com/en/5.0/ref/settings/#auth-password-validators
################################################################################


AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]


################################################################################
# Internationalization
# https://docs.djangoproject.com/en/5.0/topics/i18n/
################################################################################


LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True

UTC_OFFSET = timedelta(hours=ENV_DATA["UTC_OFFSET"])  # Washington D.C.
LOCAL_TIMEZONE = timezone(UTC_OFFSET)


################################################################################
# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.1/howto/static-files/
################################################################################


# STATIC_ROOT = BASE_DIR / "staticfiles/"

# https://docs.djangoproject.com/en/dev/ref/settings/#static-url
# STATIC_URL needs to be set to "assets" for USWDS to import icons properly

STATIC_URL = "assets/"
STATICFILES_DIRS = [BASE_DIR / "public"]

# Default primary key field type
# https://docs.djangoproject.com/en/5.0/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"


################################################################################
# Logging
################################################################################


LOG_FILE_PATH = Path(BASE_DIR / ENV_DATA["LOG_FILE_PATH"]).resolve()
create_directory(LOG_FILE_PATH.parent)
LOG_FILE_PATH.parent.resolve(strict=True)

# If we output JSON, we want the file extension to reflect JSON Lines (.jsonl)
if ENV_DATA["LOG_FORMATTER"] == "json" and LOG_FILE_PATH.suffix != ".jsonl":
    LOG_FILE_PATH = LOG_FILE_PATH.parent / Path(LOG_FILE_PATH.name + ".jsonl")  # type: ignore

LOGGING = {  # type: ignore
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "simple": {
            # https://docs.python.org/3.11/library/logging.html#logrecord-attributes
            "format": "[{asctime}] [{levelname}] {name} - {message} - {filename}:{lineno}",
            "datefmt": "%Y-%m-%dT%H:%M:%S%z",
            "style": "{",
        },
        "json": {  # for Json structured logging
            "()": "django_project.logger.JsonFormatter",
            # https://docs.python.org/3.11/library/logging.html#logrecord-attributes
            "fmt_keys": {
                "level": "levelname",
                "message": "message",
                "timestamp": "timestamp",
                "logger": "name",
                "module": "module",
                "function": "funcName",
                "line": "lineno",
                "thread_name": "threadName",
            },
        },
    },
    "handlers": {
        "stdout": {
            "class": "logging.StreamHandler",
            "formatter": "simple",
            "stream": "ext://sys.stdout",
        },
        "file": {
            "class": "logging.handlers.RotatingFileHandler",
            "level": "DEBUG",
            "formatter": ENV_DATA["LOG_FORMATTER"],
            "filename": LOG_FILE_PATH,
            "maxBytes": ENV_DATA["LOG_FILE_SIZE"],
            "backupCount": ENV_DATA["LOG_FILE_ROTATION"],
        },
    },
    "loggers": {
        "root": {"level": ENV_DATA["LOG_LEVEL"], "handlers": ["stdout", "file"]}
    },
}


################################################################################
# Main
################################################################################


def main() -> int:
    """Main function primarily used for debugging"""
    # breakpoint()
    return 0


if __name__ == "__main__":
    main()
