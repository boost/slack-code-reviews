# frozen_string_literal: true

json.response_type action.visibility || :ephemeral
json.text action.text.html_safe
