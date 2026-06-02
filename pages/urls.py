from django.urls import path

from .views import homePageView, news_list_view

urlpatterns = [
    path("", homePageView, name="home"),
    path("news/", news_list_view, name="news_list"),
]
