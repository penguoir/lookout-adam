require 'open-uri'
require 'rss'

class Feed < ApplicationRecord
  def entries
    Nokogiri::XML(open(self.google_alerts_url)).css("entry")
  end
end
