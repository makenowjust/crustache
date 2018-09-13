require "json"

def inspect_any(any)
  if hash = any.as_h?
    if hash.empty?
      "{} of String => String"
    else
      pairs = hash.map do |key, value|
        if key == "lambda"
          ruby_proc = value.as_h["ruby"].as_s
          crystal_proc = ruby_proc
            .gsub(/^proc \{ (?:(?:\|)([^|]+)(?:\|))?/){|m, p| "->(#{p[1]? ? "#{p[1]} : String" : ""}){"}
            .gsub(/\$/, "Global.").gsub(/1/, "1; Global.calls.to_s").gsub(/false/, "false.to_s")
          "#{key.inspect} => #{crystal_proc}"
        else
          "#{key.inspect} => #{inspect_any value}"
        end
      end

      "{#{pairs.join ","}}"
    end
  elsif array = any.as_a?
    if array.empty?
      "[] of String"
    else
      vals = array.map{|x| inspect_any(x).as(String) }
      "[#{vals.join ","}]"
    end
  else
    "#{any.inspect}"
  end
end

filename = ARGV[0]

file = (JSON.parse File.read "./spec/mustache-spec/specs/#{filename}").as_h

puts "describe #{filename.inspect} do"
file["tests"].as_a.each do |test|
  test = test.as_h

  puts "    it #{test["desc"].inspect} do"
  puts "      template = Crustache.parse #{test["template"].inspect}"
  puts "      expected = #{test["expected"].inspect}"

  puts "      data = #{inspect_any test["data"]}"

  puts "      fs = Crustache::HashFileSystem.new"
  if test.has_key?("partials")
    test["partials"].as_h.each do |name, tmpl|
      puts "      fs.register #{name.inspect}, Crustache.parse #{tmpl.inspect}"
    end
  end

  puts "      result = Crustache.render template, data, fs"
  puts "      result.should eq expected"
  puts "    end"
end
puts "  end"
