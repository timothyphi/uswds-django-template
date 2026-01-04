from django_components import Component, register


@register("accordion")
class Accordion(Component):
    """
    USWDS Accordion Component

    Usage:
        {% component "accordion" items=items bordered=True %}

    Where items is a list of dicts with 'title' and 'content' keys
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
