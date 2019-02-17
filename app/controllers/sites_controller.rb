class SitesController < ApplicationController
  def index
    sites = Site.where enabled: true

    render json: sites
  end

  def create
    # パラメータが無いときにエラーにする
    if params['url'] then
      url = params['url']
    else
      render json: error(1)
      return
    end

    # 新規追加ならinsert
    # 過去に無効化したサイトならupdate
    disabled_site = Site.find_by enabled: false, url: url
    if disabled_site then
      # update
      disabled_site.enabled = true
      site = disabled_site
    else
      # insert
      begin
        rss_data = RssService.new.fetch url
        name = rss_data.channel.title
        site = Site.new(name: name, url: url, enabled: true)
      rescue => e
        render json: error(3)
      end
    end

    if site.save then
      render json: {error: false}
    else
      render json: error(2)
    end
  end

  def destroy
    # パラメータが無いときにエラーにする
    if params['id'] then
      id = params['id']
    else
      render json: error(1)
      return
    end

    target_site = Site.find id
    target_site.enabled = false
    if target_site.save then
      render json: {error: false}
    else
      render json: error(2)
    end
  end

  private

  def error(code)
    {error: true, code: code}
  end
end
