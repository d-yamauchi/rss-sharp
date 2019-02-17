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
    disabledSite = Site.find_by enabled: false, url: url
    if disabledSite then
      # update
      disabledSite.enabled = true
      site = disabledSite
    else
      # insert
      name = "hoge"
      site = Site.new(name: name, url: url, enabled: true)
    end

    if site.save then
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
