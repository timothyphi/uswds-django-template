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

from dotenv import load_dotenv
from django_components import ComponentsSettings, ContextBehavior


def create_directory(folderpath: Path) -> None:
    """Creates a directory if it doesn't already exist"""
    os.makedirs(folderpath, exist_ok=True)


def get_env(key: str, default: str | None = None, required: bool = False) -> str:
    """Get environment variable with optional default and required validation"""
    value = os.getenv(key, default)
    if required and value is None:
        raise ValueError(f"Required environment variable '{key}' is not set")
    return value or ""


def get_env_bool(key: str, default: bool = False) -> bool:
    """Get boolean environment variable"""
    value = os.getenv(key, str(default)).lower()
    return value in ("true", "1", "yes", "on")


def get_env_int(key: str, default: int = 0) -> int:
    """Get integer environment variable"""
    try:
        return int(os.getenv(key, str(default)))
    except ValueError:
        return default


def get_env_list(key: str, default: list[str] | None = None) -> list[str]:
    """Get comma-separated list from environment variable"""
    value = os.getenv(key, "")
    if not value and default:
        return default
    return [item.strip() for item in value.split(",") if item.strip()]


# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent.parent

# Load environment variables from .env file if it exists
# If not found, will fall back to system environment variables
load_dotenv(BASE_DIR / ".env")

MODE = get_env("MODE", "dev")
CONFIG_PORT = get_env_int("PORT", 8000)
CONFIG_HOST = get_env("HOST", "localhost")

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.0/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = get_env("SECRET_KEY", required=True)

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = get_env_bool("DEBUG", default=(MODE != "prod"))

ALLOWED_HOSTS = get_env_list("ALLOWED_HOSTS", [CONFIG_HOST])


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
    "django_components",
    "core",
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
            "builtins": [
                "django_components.templatetags.component_tags",
            ],
        },
    },
]

# Django Components Configuration
defaults = ComponentsSettings(
    autodiscover=True,
    cache=None,
    context_behavior=ContextBehavior.DJANGO.value,  # "django" | "isolated"
    # Root-level "components" dirs, e.g. `/path/to/proj/components/`
    dirs=[Path(BASE_DIR) / "components"],
    # App-level "components" dirs, e.g. `[app]/components/`
    app_dirs=["components"],
    debug_highlight_components=False,
    debug_highlight_slots=False,
    dynamic_component_name="dynamic",
    extensions=[],
    extensions_defaults={},
    libraries=[],  # E.g. ["mysite.components.forms", ...]
    multiline_tags=True,
    reload_on_file_change=False,
    static_files_allowed=[
        ".css",
        ".js", ".jsx", ".ts", ".tsx",
        # Images
        ".apng", ".png", ".avif", ".gif", ".jpg",
        ".jpeg", ".jfif", ".pjpeg", ".pjp", ".svg",
        ".webp", ".bmp", ".ico", ".cur", ".tif", ".tiff",
        # Fonts
        ".eot", ".ttf", ".woff", ".otf", ".svg",
    ],
    static_files_forbidden=[
        # See https://marketplace.visualstudio.com/items?itemName=junstyle.vscode-django-support
        ".html", ".django", ".dj", ".tpl",
        # Python files
        ".py", ".pyc",
    ],
    tag_formatter="django_components.component_formatter",
    template_cache_size=128,
)

WSGI_APPLICATION = "django_project.wsgi.application"


################################################################################
# Database
# https://docs.djangoproject.com/en/5.0/ref/settings/#databases
################################################################################


DB_HOST = get_env("DB_HOST", "")
DB_PORT = get_env_int("DB_PORT", 1433)
DB_NAME = get_env("DB_NAME", "")
DB_USER = get_env("DB_USER", "")
DB_PASS = get_env("DB_PASS", "")

# Redis Configuration
REDIS_HOST = get_env("REDIS_HOST", "localhost")
REDIS_PORT = get_env_int("REDIS_PORT", 6379)
REDIS_DB = get_env_int("REDIS_DB", 0)

# Database configuration - use SQL Server if credentials are provided, otherwise SQLite
if DB_HOST and DB_NAME and DB_USER and DB_PASS:
    DATABASES = {  # type: ignore
        "default": {
            "ENGINE": "mssql",
            "NAME": DB_NAME,
            "USER": DB_USER,
            "PASSWORD": DB_PASS,
            "HOST": DB_HOST,
            "PORT": str(DB_PORT),
            "OPTIONS": {
                "driver": "ODBC Driver 18 for SQL Server",
                "extra_params": "TrustServerCertificate=yes",
            },
        }
    }
else:
    # Fallback to SQLite for local development
    DATABASES = {  # type: ignore
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": BASE_DIR / "db.sqlite3",
        }
    }


################################################################################
# Cache Configuration (Redis)
# https://docs.djangoproject.com/en/5.0/topics/cache/
################################################################################


CACHES = {  # type: ignore
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_DB}",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        },
        "KEY_PREFIX": "uswds_django",
        "TIMEOUT": 300,  # 5 minutes default timeout
    }
}

# Use Redis for session storage
SESSION_ENGINE = "django.contrib.sessions.backends.cache"
SESSION_CACHE_ALIAS = "default"


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

UTC_OFFSET = timedelta(hours=get_env_int("UTC_OFFSET", -5))  # Washington D.C.
LOCAL_TIMEZONE = timezone(UTC_OFFSET)


################################################################################
# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.1/howto/static-files/
################################################################################


STATIC_ROOT = BASE_DIR / "staticfiles/"

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


LOG_FORMATTER = get_env("LOG_FORMATTER", "simple")

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
            "formatter": LOG_FORMATTER,
            "stream": "ext://sys.stdout",
        },
    },
    "loggers": {"root": {"level": get_env("LOG_LEVEL", "INFO"), "handlers": ["stdout"]}},
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
