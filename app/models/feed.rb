require 'open-uri'

class Feed < ApplicationRecord
  def rss_feed
    puts "heya"
    Nokogiri::XML(open(self.google_alerts_url))
  end
end
