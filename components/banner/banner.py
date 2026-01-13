from django_components import Component, register


@register("banner")
class Banner(Component):
    """
    USWDS Official Government Banner Component

    Displays the official U.S. government website banner that identifies the site
    as an official government website. Should be placed at the very top of the page.

    Parameters:
        None - This component takes no parameters

    Usage:
        {% component "banner" %}
          Official Government Banner
        {% endcomponent %}

    Note:
        The banner content is typically provided in the template between the opening
        and closing tags. In most cases, you can use the default text as shown above.
        This component is usually included once in the base layout template.
    """

    template_name = "banner/banner.html"

    def get_context_data(self):
        return {}

    class Media:
        css = "banner/banner.css"
        js = "banner/banner.js"
