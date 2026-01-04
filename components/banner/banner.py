from django_components import Component, register


@register("banner")
class Banner(Component):
    """
    USWDS Official Government Banner Component

    Usage:
        {% component "banner" %}
    """

    template_name = "banner/banner.html"

    def get_context_data(self):
        return {}

    class Media:
        css = "banner/banner.css"
        js = "banner/banner.js"
