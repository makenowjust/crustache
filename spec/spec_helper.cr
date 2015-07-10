require "spec"
require "json"

require "../src/crustache"

def spec_json(filename)
  file = (JSON.parse File.read "./spec/mustache-spec/specs/#{filename}") as Hash(String, JSON::Type)
  describe filename do
    (file["tests"] as Array(JSON::Type)).each do |test|
      test = test as Hash(String, JSON::Type)
      it test["desc"] do
        template = Crustache.parse (test["template"] as String)
        expected = test["expected"]
        data = test["data"] as Hash(String, JSON::Type)
        fs = Crustache::FileSystem.new
        if test.has_key?("partials")
          (test["partials"] as Hash(String, JSON::Type)).each do |name, tmpl|
            fs.register name, Crustache.parse (tmpl as String)
          end
        end
        result = Crustache.render template, data, fs
        result.should eq expected
      end
    end
  end
end
