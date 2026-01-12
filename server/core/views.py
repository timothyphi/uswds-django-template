"""Views for the core app."""

from django.http import HttpResponse


def health_check(request):
    """Simple health check endpoint that returns 200 OK."""
    return HttpResponse(b"OK", content_type="text/plain", status=200)
