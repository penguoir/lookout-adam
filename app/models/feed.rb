require 'open-uri'
require 'rss'

class Feed < ApplicationRecord
  def entries
    document = Nokogiri::XML(open(self.google_alerts_url))

    document.css("entry").map do |entry|
      # Get the page of the entry
      google_provided_link = entry.at_css("link").attributes["href"].value
      decoded_link = URI::decode_www_form(google_provided_link)
      parameters = decoded_link.to_h
      page_link = URI(parameters["url"])
      page = Net::HTTP.get(page_link)
      document = Nokogiri::HTML.parse(page)

      if entry.at_css("published").content
        pubDate = DateTime.parse(entry.at_css("published").content).rfc2822
      end

      # We now have the parsed HTML of the webpage in the var "document"
      # which we can use to get all the info we need

      # Title
      # =====
      # 1) <meta property="og:title">
      # 2) <title>
      # 3) first h1
      # 4) (no title)

      title = "(no title)"

      if document.at_css("meta[property='og:title']")
        title = document.at_css("meta[property='og:title']").attribute("content").content
      elsif document.at_css("title")
        title = document.at_css("title").content
      elsif document.at_css("h1")
        title = document.at_css("h1").content
      end

      # Description
      # ===========
      # 1) <meta property="og:description" content="">
      # 2) <meta name="description">
      # 3) The first <p> tag in the <article>
      # 4) The first <p> tag
      # 5) (no description)

      description = "(no description)"

      if document.at_css("meta[property='og:descriotion']")
        description = document.at_css("meta[property='og:descriotion']")["content"]
      elsif document.at_css("meta[name='description']")
        description = document.at_css("meta[name='description']")["content"]
      elsif document.at_css("article p")
        description = document.at_css("article p").content
      elsif document.at_css("p")
        description = document.at_css("p").content
      end


      # Return a hash of all the values
      {
        :title => title,
        :description => description,
        :link => page_link,
        :pub_date => pubDate
      }
    end
  end
end
