from django_components import Component, register


@register("button")
class Button(Component):
    """
    USWDS Button Component

    Provides styled buttons with various types and sizes following USWDS design system.

    Parameters:
        text (str): Button text content (required)
        type (str): Button style - "default", "primary", "secondary", "accent-cool",
                    "base", "outline", or "outline inverse" (default: "default")
        size (str): Button size - "big" or None for normal (default: None)
        url (str): Optional URL to make the button a link (default: None)
        submit (bool): If True, renders as submit button (default: False)

    Usage:
        {% component "button"
          text="Click me"
        %}
        {% endcomponent %}

        {% component "button"
          text="Submit Form"
          type="primary"
          submit=True
        %}
        {% endcomponent %}

        {% component "button"
          text="Learn More"
          type="outline"
          url="/about"
        %}
        {% endcomponent %}

        {% component "button"
          text="Big Primary Button"
          type="primary"
          size="big"
        %}
        {% endcomponent %}
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
