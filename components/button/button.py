from django_components import Component, register


@register("button")
class Button(Component):
    """
    USWDS Button Component

    Usage:
        {% component "button" text="Click me" %}
        {% component "button" text="Submit" type="primary" submit=True %}
        {% component "button" text="Learn More" url="/about" type="outline" %}
    """

    template_name = "button/button.html"

    def get_context_data(self, text, type="default", size=None, url=None, submit=False):
        return {
            "text": text,
            "type": type,
            "size": size,
            "url": url,
            "submit": submit,
        }

    class Media:
        css = "button/button.css"
