from django.conf.urls import patterns, include, url
from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),
    url(r'^admin/', include(admin.site.urls)),
    url(r'', include('social_auth.urls')),
    (r'^accounts/login/$', 'django.contrib.auth.views.login',
     {'template_name': 'db_beers/django-login.html'}),
    url(r'^db-beers/', include('db_beers.urls')),
)
