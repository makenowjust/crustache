require "json"

def inspect_any(any)
  if hash = any.as_h?
    if hash.empty?
      "{} of String => String"
    else
      pairs = hash.map do |key, value|
        if key == "lambda"
          languages = value.as_h
          crystal_proc = if languages.has_key? "crystal"
                           languages["crystal"].as_s
                         else
                           languages["ruby"].as_s
                             .gsub(/^proc \{ (?:(?:\|)([^|]+)(?:\|))?/){|m, p| "->(#{p[1]? ? "#{p[1]} : String" : ""}){"}
                             .gsub(/\$/, "Global.").gsub(/1/, "1; Global.calls.to_s").gsub(/false/, "false.to_s")
                         end
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

spec_path = ARGV[0]
filename = ARGV[1]

file = (JSON.parse File.read "./spec/#{spec_path}/#{filename}").as_h

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
