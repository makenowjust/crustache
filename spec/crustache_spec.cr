require "./spec_helper"

describe Crustache do
  %w(interpolation sections inverted delimiters comments partials).each do |name|
    spec_json "#{name}.json"
  end
end
