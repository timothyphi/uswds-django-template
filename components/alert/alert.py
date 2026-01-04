from django_components import Component, register


@register("alert")
class Alert(Component):
    """
    USWDS Alert Component

    Usage:
        {% component "alert" type="success" heading="Success!" message="Operation completed." %}
        {% component "alert" type="info" message="Information message." slim=True %}
    """

    template_name = "alert/alert.html"

    def get_context_data(self, type="info", heading=None, message="", slim=False):
        return {
            "type": type,
            "heading": heading,
            "message": message,
            "slim": slim,
        }

    class Media:
        css = "alert/alert.css"
