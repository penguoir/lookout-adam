require 'date'

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
        # Parse the title
        title = entry.css("title").text
        xml.title Nokogiri::HTML.parse(title).text
        
        # Parse the description
        content = entry.css("content").text
        xml.description Nokogiri::HTML.parse(content).text

        # Date
        if entry.at_css("published").content
          xml.pubDate DateTime.parse(entry.at_css("published").content).rfc2822
        end

        # Guid
        xml.guid entry.at_css("link").attributes["href"]
        xml.link entry.at_css("link").attributes["href"]
      end
    end
  end
end
