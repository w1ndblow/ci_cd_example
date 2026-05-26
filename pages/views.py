from django.http import HttpResponse
from django.shortcuts import render

from .models import News


def homePageView(request):
    return HttpResponse("Hello, World!")


def dataPageView(request):
    return HttpResponse("Hello, World!")


def news_list_view(request):
    """View to display a list of published news articles"""
    news_list = News.objects.filter(is_published=True).order_by("-created_at")
    context = {
        "news_list": news_list,
    }
    return render(request, "pages/news_list.html", context)
