from django.db import models
from django.urls import reverse
from django.utils import timezone


class News(models.Model):
    """Model representing a news article"""

    title = models.CharField(max_length=200, verbose_name="Title")
    content = models.TextField(verbose_name="Content")
    author = models.CharField(max_length=100, verbose_name="Author")
    created_at = models.DateTimeField(default=timezone.now, verbose_name="Created At")
    updated_at = models.DateTimeField(auto_now=True, verbose_name="Updated At")
    is_published = models.BooleanField(default=True, verbose_name="Is Published")

    class Meta:
        verbose_name = "News"
        verbose_name_plural = "News"
        ordering = ["-created_at"]

    def __str__(self):
        return self.title

    def get_absolute_url(self):
        return reverse("news_detail", kwargs={"pk": self.pk})
