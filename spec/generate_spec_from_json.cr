require "json"

def inspect_hash(hash)
  if hash.is_a?(Hash)
    if hash.empty?
      "({} of String => Type) as Type"
    else
      pairs = hash.map do |key, value|
        if key == "lambda"
          "#{key.inspect} => (#{((value as Hash(String, JSON::Type))["ruby"] as String).gsub(/^proc \{ (?:(?:\|)([^|]+)(?:\|))?/){|m, p| "->(#{p[1]? ? "#{p[1]} : String" : ""}){"}.gsub(/1/, "1; $calls.to_s").gsub(/false/, "false.to_s")} as Type)"
        else
          "#{key.inspect} => #{inspect_hash value}"
        end
      end

      "({#{pairs.join ","}} of String => Type) as Type"
    end
  elsif hash.is_a?(Array)
    if hash.empty?
      "([] of Type) as Type"
    else
      vals = hash.map{|x| inspect_hash(x) as String}
      "([#{vals.join ","}] of Type) as Type"
    end
  elsif hash.is_a?(Int)
    "#{hash.inspect}_i64 as Type"
  else
    "#{hash.inspect} as Type"
  end
end

filename = ARGV[0]

file = (JSON.parse File.read "./spec/mustache-spec/specs/#{filename}") as Hash(String, JSON::Type)

puts "describe #{filename.inspect} do"
(file["tests"] as Array(JSON::Type)).each do |test|
  test = test as Hash(String, JSON::Type)

  puts "    it #{test["desc"].inspect} do"
  puts "      template = Crustache.parse #{test["template"].inspect}"
  puts "      expected = #{test["expected"].inspect}"

  puts "      data = #{inspect_hash test["data"]}"

  puts "      fs = Crustache::HashFileSystem.new"
  if test.has_key?("partials")
    (test["partials"] as Hash(String, JSON::Type)).each do |name, tmpl|
      puts "      fs.register #{name.inspect}, Crustache.parse #{tmpl.inspect}"
    end
  end

  puts "      result = Crustache.render template, data as Type, fs"
  puts "      result.should eq expected"
  puts "    end"
end
puts "  end"
