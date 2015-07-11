require "./spec_helper"

# for ~lambda.json test
$calls = 0

{% for name in %w(interpolation sections inverted delimiters comments partials ~lambdas) %}
  {{ run "./generate_spec_from_json", "#{name.id}.json" }}
{% end %}
