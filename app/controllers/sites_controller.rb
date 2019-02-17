class SitesController < ApplicationController
  def index
    sites = Site.where('enabled = 1')

    render json: sites
  end

  def create
    if params['url'] then
      url = params['url']
    else
      render json: error(1)
      return
    end

    name = "hoge"
    site = Site.new(name: name, url: url, enabled: true)
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
