require 'date'
require 'cgi'
require 'net/http'

xml.instruct! :xml, :version => "1.0"
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title @feed.title
    xml.link feed_url(@feed, :format => :rss)
    xml.description "Google alert for '%s'" % @feed.title
    xml.language "en-uk"

    # TODO: uncomment when program is stable
    # xml.ttl "60"

    @feed.entries.each do |entry|
      xml.item do
        puts entry
        xml.title entry[:title]
        xml.description entry[:description]
        xml.guid entry[:link]
        xml.link entry[:link]
        xml.pubDate entry[:pub_date]
      end
    end
  end
end
