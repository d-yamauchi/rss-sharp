require "date"

class FetchRssJob < ApplicationJob
  queue_as :default

  def perform(*args)
    log "更新処理を開始します。"

    newItems = []
    sites = Site.where enabled: true
    sites.each do |site|
      log "#{site.name}を取得します。"

      oldItems = Item.where({site_id: site.id}).reverse

      rss_data = RssService.new.fetch site.url
      rss_data.items.each do |item|
        next if !item.title
        next if !item.link
        next if oldItems.any? { |oldItem| oldItem.url == item.link}

        newItems << Item.new({title: item.title, url: item.link, unread: true, site_id: site.id})
      end
    end

    Item.import newItems

    log "#{newItems.length}件更新しました。"
    log "更新処理を終了します。"
  end

  private

  def log(text)
    p "[#{DateTime.now}] #{text}"
  end
end
