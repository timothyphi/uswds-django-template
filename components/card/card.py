from django_components import Component, register


@register("card")
class Card(Component):
    """
    USWDS Card Component

    Usage:
        {% component "card" title="Card Title" description="Card description text" %}
        {% component "card" title="Featured" description="Description" link_url="/page" link_text="Read More" %}
    """

    template_name = "card/card.html"

    def get_context_data(
        self,
        title,
        description,
        media_url=None,
        media_alt=None,
        link_url=None,
        link_text="Visit",
        flag=False
    ):
        return {
            "title": title,
            "description": description,
            "media_url": media_url,
            "media_alt": media_alt or title,
            "link_url": link_url,
            "link_text": link_text,
            "flag": flag,
        }

    class Media:
        css = "card/card.css"
