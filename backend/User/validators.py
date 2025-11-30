from django.core.exceptions import ValidationError
import re


def validate_strong_password(value):
    if len(value) < 8:
        raise ValidationError("Password must be at least 8 characters long.")
    if not re.search(r"[A-Za-z]", value) or not re.search(r"\d", value):
        raise ValidationError(
            "Password must contain at least one letter and one number."
        )
