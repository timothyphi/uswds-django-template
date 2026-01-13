from django_components import Component, register


@register("card")
class Card(Component):
    """
    USWDS Card Component

    Variants:
        - Default card: Basic card with title, body, and optional footer
        - Flag layout: Horizontal card with media on left (or right with media_right=True)
        - Header first: Display header before media (header_first=True)
        - Media variants: inset, exdent positioning

    Usage:
        {% component "card" title="Card Title" description="Card description text" %}
        {% component "card" title="Card" description="Text" link_url="#" link_text="Visit" %}
        {% component "card" title="With Media" media_url="/img.jpg" description="Text" %}
        {% component "card" title="Flag" flag=True media_url="/img.jpg" description="Text" %}
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
        flag=False,
        header_first=False,
        media_right=False,
        media_inset=False,
        media_exdent=False,
        grid_col=None,
    ):
        return {
            "title": title,
            "description": description,
            "media_url": media_url,
            "media_alt": media_alt or title,
            "link_url": link_url,
            "link_text": link_text,
            "flag": flag,
            "header_first": header_first,
            "media_right": media_right,
            "media_inset": media_inset,
            "media_exdent": media_exdent,
            "grid_col": grid_col,
        }

    class Media:
        css = "card/card.css"
