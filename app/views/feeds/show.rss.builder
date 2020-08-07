xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Google alert - %s" % @feed.title
    xml.link feed_url(@feed, :format => :rss)

    @feed.rss_feed.css("entry").each do |entry|
      xml.item do |e|
        # Parse the title
        title = entry.css("title").text
        e.title Nokogiri::HTML.parse(title).text
        
        # Parse the description
        content = entry.css("content").text
        e.description Nokogiri::HTML.parse(content).text

        e.pubDate entry.css("published").text
        e.guid entry.css("id").text
        e.link entry.css("link").first.attributes["href"]
      end
    end
  end
end
