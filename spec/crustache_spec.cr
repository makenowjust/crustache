require "./spec_helper"

describe Crustache do
  describe "#parse" do
    it "shold parse a string" do
      Crustache.parse("Hello, {{Mustache}} World").should be_truthy
    end

    it "should parse a IO" do
      Crustache.parse(StringIO.new "Hello, {{Mustache}} World").should be_truthy
    end

    it "raise a parse error" do
      expect_raises(Crustache::ParseError) do
        Crustache.parse("Hello, {{Mustache? World")
      end
    end
  end

  describe "#parseFile" do
    it "should parse a file" do
      Crustache.parse("#{__DIR__}/view/template.mustache").should be_truthy
    end
  end

  describe "#render" do
    it "should render a template" do
      Crustache.render(Crustache.parse("Test {{.}}"), "Test").should eq("Test Test")
    end
  end
end

require "./mustache_spec"
require "./view_loader_spec"
require "./engine_spec"
