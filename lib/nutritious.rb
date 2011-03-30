require 'open-uri'
require 'json'

require 'feedzirra'
require 'hpricot'

module Nutritious

  def self.process_single_bookmark(e)
    # entry id example: @entry_id="http://www.delicious.com/url/db62a351ed098a6d8acc42a620d4cfde#quilombosam"
    entry_id = $1 if e.entry_id =~ /.*url\/(.+)#/

    # load 20 latest tags
    all_tags = Hash.new(0)
    e.categories.each { |cat| all_tags[cat] += 1 }
    detailed_feed = Feedzirra::Feed.fetch_and_parse("http://feeds.delicious.com/v2/rss/url/#{entry_id}?count=20")
    detailed_feed.entries.each { |p| p.categories.each { |cat| all_tags[cat] += 1 } }

    # take only best tags
    consensus_tags = all_tags.to_a.sort{ |a,b| a[1] <=> b[1]}.reverse.slice(0,5).reject { |t| t[1]<3 }
    if consensus_tags.empty?
      return nil
    end

    # load doc body
    doc = open(e.url) { |f| Hpricot(f) }
    doc.search("script").remove
    doc.search("style").remove
    body = doc.search("body").text.gsub(/\s+/, ' ')

    #collect
    {:url => e.url, :title =>e.title, :tags => consensus_tags.map { |t| t[0] }, :body => body}
  rescue
    nil
  end

  def self.load_recent(count)
      feed = Feedzirra::Feed.fetch_and_parse("http://feeds.delicious.com/v2/rss/recent?min=2&count=#{count}")
      feed.entries.each do |e|
        rr = process_single_bookmark(e)
        yield rr if rr && block_given?
      end
  end

end