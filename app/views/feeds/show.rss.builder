xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Google alert - %s" % @feed.title

    @feed.rss_feed.css("entry").each do |entry|
      xml.entry do |e|
        e.id entry.css("id").text
        e.published entry.css("published").text
        e.updated entry.css("updated").text

        e.link entry.css("link").first.attributes

        # Parse the title
        title = entry.css("title").text
        e.title Nokogiri::HTML.parse(title).text
        
        # Parse the content
        content =  entry.css("content").text
        e.content Nokogiri::HTML.parse(content).text
      end
    end
  end
end
