#encoding;utf-8
require 'nutritious'

File.open('test.json', 'a') do |f|
  Nutritious.load_recent(100) do |bookmark|
    f.puts bookmark.to_json
    f.flush
    print "."
  end
end

