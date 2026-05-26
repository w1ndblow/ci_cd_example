
from django.conf import settings
from django.test import Client, TestCase, override_settings
from django.urls import reverse

from .models import News


class UnitTestCase(TestCase):
    """Unit tests for the pages app"""

    def setUp(self):
        """Set up test client"""
        self.client = Client()

    def test_home_page_status_code(self):
        """Test that the home page returns a 200 status code"""
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)

    def test_home_page_content(self):
        """Test that the home page contains the expected content"""
        response = self.client.get("/")
        self.assertContains(response, "Hello, World!")


class NewsModelTestCase(TestCase):
    """Tests for the News model"""

    def setUp(self):
        """Create sample news items for testing"""
        self.news1 = News.objects.create(
            title="Test News 1",
            content="This is the content of test news 1.",
            author="Test Author 1",
        )
        self.news2 = News.objects.create(
            title="Test News 2",
            content="This is the content of test news 2.",
            author="Test Author 2",
            is_published=False,
        )

    def test_news_str_representation(self):
        """Test that the news string representation is correct"""
        self.assertEqual(str(self.news1), "Test News 1")

    def test_news_ordering(self):
        """Test that news are ordered by creation date descending"""
        news_items = News.objects.all()
        self.assertEqual(news_items.first(), self.news2)  # Most recent first

    def test_published_news_filter(self):
        """Test that only published news are returned by default"""
        published_news = News.objects.filter(is_published=True)
        self.assertIn(self.news1, published_news)
        self.assertNotIn(self.news2, published_news)


class NewsListViewTestCase(TestCase):
    """Tests for the news list view"""

    def setUp(self):
        """Set up test client and sample news"""
        self.client = Client()
        self.news1 = News.objects.create(
            title="Published News",
            content="This is published news content.",
            author="Author 1",
        )
        self.news2 = News.objects.create(
            title="Unpublished News",
            content="This is unpublished news content.",
            author="Author 2",
            is_published=False,
        )

    def test_news_list_view_status_code(self):
        """Test that the news list view returns a 200 status code"""
        response = self.client.get("/news/")
        self.assertEqual(response.status_code, 200)

    def test_news_list_view_contains_published_news(self):
        """Test that the news list view contains published news"""
        response = self.client.get("/news/")
        self.assertContains(response, "Published News")
        self.assertContains(response, "Author 1")

    def test_news_list_view_excludes_unpublished_news(self):
        """Test that the news list view excludes unpublished news"""
        response = self.client.get("/news/")
        self.assertNotContains(response, "Unpublished News")

    def test_news_list_view_uses_correct_template(self):
        """Test that the news list view uses the correct template"""
        response = self.client.get("/news/")
        self.assertTemplateUsed(response, "pages/news_list.html")


class PostgresIntegrationTestCase(TestCase):
    """Integration tests with PostgreSQL database"""

    databases = "__all__"

    def setUp(self):
        """Set up test environment"""
        self.client = Client()

    @override_settings(
        DATABASES={
            "default": {
                "ENGINE": "django.db.backends.postgresql",
                "NAME": "test_db",
                "USER": "test_user",
                "PASSWORD": "test_password",
                "HOST": "localhost",
                "PORT": "5432",
            }
        }
    )
    def test_postgres_database_settings(self):
        """Test that PostgreSQL settings are properly configured"""

        db_config = settings.DATABASES["default"]
        self.assertEqual(db_config["ENGINE"], "django.db.backends.postgresql")
        self.assertEqual(db_config["NAME"], "test_db")
        self.assertEqual(db_config["USER"], "test_user")

    def test_home_page_with_postgres_context(self):
        """Test home page functionality in PostgreSQL context"""
        # Even though our view doesn't use database, we test it in PostgreSQL context
        with override_settings(
            DATABASES={
                "default": {
                    "ENGINE": "django.db.backends.postgresql",
                    "NAME": "test_app",
                    "USER": "test_app",
                    "PASSWORD": "test_app",
                    "HOST": "test_host",
                    "PORT": "5432",
                }
            }
        ):
            response = self.client.get(reverse("home"))
            self.assertEqual(response.status_code, 200)
            self.assertContains(response, "Hello, World!")
            response = self.client.get("/news/")
            self.assertEqual(response.status_code, 200)
