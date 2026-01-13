"""Views for the core app."""

from django.http import HttpResponse
from django.shortcuts import render


def health_check(request):
    """Simple health check endpoint that returns 200 OK."""
    return HttpResponse(b"OK", content_type="text/plain", status=200)


def component_demo(request):
    """Demo page showcasing all available USWDS components."""
    context = {
        "accordion_items": [
            {
                "title": "First Amendment",
                "content": "<p>Congress shall make no law respecting an establishment of religion, or prohibiting the free exercise thereof; or abridging the freedom of speech, or of the press; or the right of the people peaceably to assemble, and to petition the Government for a redress of grievances.</p>",
            },
            {
                "title": "Second Amendment",
                "content": "<p>A well regulated Militia, being necessary to the security of a free State, the right of the people to keep and bear Arms, shall not be infringed.</p>",
            },
            {
                "title": "Third Amendment",
                "content": "<p>No Soldier shall, in time of peace be quartered in any house, without the consent of the Owner, nor in time of war, but in a manner to be prescribed by law.</p>",
            },
            {
                "title": "Fourth Amendment",
                "content": "<p>The right of the people to be secure in their persons, houses, papers, and effects, against unreasonable searches and seizures, shall not be violated, and no Warrants shall issue, but upon probable cause, supported by Oath or affirmation, and particularly describing the place to be searched, and the persons or things to be seized.</p>",
            },
        ],
    }
    return render(request, "component_demo.html", context)
