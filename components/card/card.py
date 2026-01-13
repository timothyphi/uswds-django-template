from django_components import Component, register


@register("card")
class Card(Component):
    """
    USWDS Card Component

    Flexible card component supporting various layouts and media positioning options.

    Parameters:
        title (str): Card heading (required)
        description (str): Card body text content (required)
        media_url (str): Optional image URL for card media
        media_alt (str): Alt text for image (defaults to title if not provided)
        link_url (str): Optional URL for card footer link
        link_text (str): Link text (default: "Visit")
        flag (bool): If True, displays horizontal layout (default: False)
        header_first (bool): If True, displays header before media (default: False)
        media_right (bool): If True with flag layout, positions media on right (default: False)
        media_inset (bool): If True, adds padding around media (default: False)
        media_exdent (bool): If True, extends media beyond card border (default: False)
        grid_col (str): Optional grid column classes for responsive layout

    Variants:
        - Default card: Basic card with title, body, and optional footer
        - Flag layout: Horizontal card with media on left (or right with media_right=True)
        - Header first: Display header before media (header_first=True)
        - Media variants: inset, exdent positioning

    Usage:
        {% component "card"
          title="Card Title"
          description="Card description text"
        %}
        {% endcomponent %}

        {% component "card"
          title="Card with Link"
          description="This card has a footer link"
          link_url="/details"
          link_text="Learn more"
        %}
        {% endcomponent %}

        {% component "card"
          title="Card with Media"
          description="This card includes an image"
          media_url="/static/img/example.jpg"
          media_alt="Example image"
        %}
        {% endcomponent %}

        {% component "card"
          title="Flag Layout Card"
          description="Horizontal layout with media on left"
          flag=True
          media_url="/static/img/example.jpg"
          link_url="#"
          link_text="Visit"
        %}
        {% endcomponent %}

        {% component "card"
          title="Responsive Grid Card"
          description="Card with grid classes for responsive layout"
          grid_col="tablet:grid-col-6 tablet-lg:grid-col-4"
          link_url="#"
          link_text="Read more"
        %}
        {% endcomponent %}
    """

    template_name = "card/card.html"
    tag = ""  # No wrapper element - card template already has <li> tag

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
