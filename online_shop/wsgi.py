import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'online_shop.settings')

from django.core.wsgi import get_wsgi_application

# Must be called before any app imports so Django apps are fully loaded
application = get_wsgi_application()

# Now safe to import and call app code
from accounts.views import create_manager
create_manager()