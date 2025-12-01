from pathlib import Path
from dotenv import load_dotenv
import os
import datetime

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = os.getenv("SECRET_KEY")

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = os.getenv("DEBUG")

ALLOWED_HOSTS = ["khagan.univibe.uz", "localhost", "127.0.0.1"]

# AUTH_USER_MODEL = 'User.UserModel'


EMAIL_HOST_NAME = ""
EMAIL_HOST = "smtp.gmail.com"
EMAIL_HOST_USER = "dilshodmukhtarov1704@gmail.com"
EMAIL_HOST_PASSWORD = "dhjmuoxeyflgoniu"
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"


# Application definition

INSTALLED_APPS = [
    # third-part
    'jazzmin',
    'rest_framework',
    'corsheaders',
    # core
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'drf_yasg',
    # local
    "User",
    "Products",
    "Cart",
    "reklama",
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

CSRF_TRUSTED_ORIGINS = [
    "http://127.0.0.1",
    "http://localhost",
    "https://khagan.univibe.uz"
]


CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://api.univibe.uz",
    "https://api.univibe.uz",
    'http://localhost:5173',  
    'http://localhost:5174',  
    'http://localhost:3001',  
    'http://localhost:3003',
    "https://khagan.univibe.uz",
    "http://khagan.univibe.uz",
]

CORS_ALLOW_ALL_ORIGINS= True
CORS_ALLOW_CREDENTIALS = True

CORS_ALLOW_METHODS = (
    "DELETE",
    "GET",
    "OPTIONS",
    "PATCH",
    "POST",
    "PUT",
)

CORS_ALLOW_HEADERS = [
    "accept",
    "accept-encoding",
    "authorization",
    "authorizations",
    "content-type",
    "dnt",
    "origin",
    "user-agent",
    "x-csrftoken",
    "x-requested-with",
]

WSGI_APPLICATION = 'config.wsgi.application'


SWAGGER_SETTINGS = {
    "USE_SESSION_AUTH": False,
    "SECURITY_DEFINITIONS": {
        "Bearer": {
            "in": "header",
            "name": "Authorization",
            "type": "apiKey",
        },
    },
}

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": datetime.timedelta(days=7),
    "REFRESH_TOKEN_LIFETIME": datetime.timedelta(days=14),
    "AUTH_HEADER_TYPES": ("Bearer",),
    "AUTH_HEADER_NAME": "HTTPS_AUTHORIZATION",
    "USER_ID_CLAIM": "id",
    "USER_AUTHENTICATION_RULE": "rest_framework_simplejwt.authentication.default_user_authentication_rule",
}

REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
}

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}


# Password validation
# https://docs.djangoproject.com/en/5.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/5.2/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'Asia/Tashkent'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.2/howto/static-files/

STATIC_URL = "/static/"
STATIC_ROOT = "/app/static"
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"
STATICFILES_FINDERS = [
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
]


MEDIA_URL = "/media/"
MEDIA_ROOT = "/app/media"
# Default primary key field type
# https://docs.djangoproject.com/en/5.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

JAZZMIN_SETTINGS = {
    "site_title": "Django",
    "site_header": "Django admin",
    "site_brand": "Django admin",
    "order_with_respect_to": [
        "auth",
        "about",
        "about.workersmodel",
        "about.tradeunion",
        "about.about",
        "about.Statistics",
        "executive",
        "council",
        "post",
        "gallery",
        "doc",
        "doc.doccategory",
        "normative_doc",
        "vacancy",
        "affiliates",
        "teritory_division",
        "virtual_reception",
        "feedback",
        "information",
        "useful_link",
        "faq",
    ],
    "icons": {
        "auth.Group": "fas fa-user-friends",
        "auth.User": "fas fa-users",
        "about.WorkersModel": "fas fa-user-tie",
        "about.TradeUnion": "fas fa-user-tie",
        "about.About": "fas fa-info-circle",
        "about.Statistics": "fas fa-chart-pie",
        "affiliates.affiliates": "fas fa-people-arrows",
        "council.council": "fas fa-user-shield",
        "council.categorycouncil": "fas fa-align-justify",
        "doc.doc": "fas fa-file-alt",
        "doc.doccategory": "fas fa-align-justify",
        "executive.ExecutiveApparatus": "fas fa-user-tie",
        "faq.faq": "fas fa-question",
        "feedback.feedback": "fas fa-phone",
        "gallery.photogallery": "fas fa-images",
        "gallery.videogallery": "fas fa-video",
        "information.InfoCategory": "fas fa-align-justify",
        "information.executiveapparatusinformation": "fas fa-phone-volume",
        "normative_doc.NormativeDocCategory": "fas fa-align-justify",
        "normative_doc.NormativeDocument": "fas fa-print",
        "post.category": "fas fa-align-justify",
        "post.postmodel": "fas fa-newspaper",
        "teritory_division.TerritoryDivision": "fas fa-map-marked-alt",
        "useful_link.usefullink": "fas fa-handshake",
        "vacancy.vacancy": "fas fa-user-plus",
        "virtual_reception.VirtualReception": "fas fa-envelope",
    },
}
