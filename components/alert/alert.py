from django_components import Component, register


@register("alert")
class Alert(Component):
    """
    USWDS Alert Component

    Displays important messages to users with contextual styling based on type.

    Parameters:
        type (str): Alert type - "success", "warning", "error", or "info" (default: "info")
        heading (str): Optional heading text for the alert
        message (str): The alert message content
        slim (bool): If True, displays a compact version without icon (default: False)

    Usage:
        {% component "alert"
          type="success"
          heading="Success!"
          message="Operation completed successfully."
        %}
        {% endcomponent %}

        {% component "alert"
          type="error"
          heading="Error"
          message="An error occurred while processing your request."
        %}
        {% endcomponent %}

        {% component "alert"
          type="info"
          message="This is a slim info alert without a heading."
          slim=True
        %}
        {% endcomponent %}
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
