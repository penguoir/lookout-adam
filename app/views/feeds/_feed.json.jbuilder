json.extract! feed, :id, :title, :google_alerts_url, :created_at, :updated_at
json.url feed_url(feed, format: :json)
