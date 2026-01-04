"""
Custom Django management command to create a superuser if none exists.
This is useful for automated deployments and Docker container initialization.
"""

import os

from django.contrib.auth import get_user_model
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = "Create a superuser if no users exist in the database"

    def handle(self, *args, **options):
        User = get_user_model()

        # Check if any users exist
        if User.objects.exists():
            self.stdout.write(
                self.style.WARNING(
                    "Users already exist in the database. Skipping superuser creation."
                )
            )
            return

        # Get credentials from environment variables
        username = os.getenv("ADMIN_USERNAME", "admin")
        email = os.getenv("ADMIN_EMAIL", "admin@example.com")
        password = os.getenv("ADMIN_PASSWORD", "")

        if not password:
            self.stdout.write(
                self.style.ERROR(
                    "ADMIN_PASSWORD environment variable is not set. "
                    "Cannot create superuser."
                )
            )
            return

        try:
            # Create the superuser
            User.objects.create_superuser(
                username=username,
                email=email,
                password=password
            )
            self.stdout.write(
                self.style.SUCCESS(
                    f"Superuser '{username}' created successfully!"
                )
            )
        except Exception as e:
            self.stdout.write(
                self.style.ERROR(
                    f"Error creating superuser: {str(e)}"
                )
            )
