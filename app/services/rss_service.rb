require "rss"

class RssService
  def fetch(url)
    rss_data = RSS::Parser.parse url
    raise if rss_data == nil

    rss_data
  end
end
