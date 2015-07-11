require "spec"
require "json"

require "../src/crustache"

alias Type = JSON::Type | Array(Type) | Hash(String, Type) | (-> String) | (String -> String)
