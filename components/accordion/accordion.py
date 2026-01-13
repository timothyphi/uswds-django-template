from django_components import Component, register


@register("accordion")
class Accordion(Component):
    """
    USWDS Accordion Component

    Displays a list of headers that hide or reveal additional content when selected.

    Parameters:
        items (list): List of dictionaries with 'title' and 'content' keys (required)
        bordered (bool): If True, adds borders around accordion (default: False)
        multiselectable (bool): If True, allows multiple sections open at once (default: False)
        id_prefix (str): Prefix for accordion IDs to avoid conflicts (default: "accordion")

    Usage:

        {% component "accordion"
          items=accordion_items
        %}{% endcomponent %}

        {% component "accordion"
          items=accordion_items
          bordered=True
        %}{% endcomponent %}

        {% component "accordion"
          items=accordion_items
          multiselectable=True
          id_prefix="custom-accordion"
        %}{% endcomponent %}

    Example items structure in view:
        accordion_items = [
            {
                "title": "First Section",
                "content": "<p>Content for first section</p>"
            },
            {
                "title": "Second Section",
                "content": "<p>Content for second section</p>"
            }
        ]
    """

    template_name = "accordion/accordion.html"

    def get_context_data(self, items, bordered=False, multiselectable=False, id_prefix="accordion"):
        return {
            "items": items,
            "bordered": bordered,
            "multiselectable": multiselectable,
            "id_prefix": id_prefix,
        }

    class Media:
        css = "accordion/accordion.css"
