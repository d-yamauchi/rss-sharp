class ItemsController < ApplicationController
  def index
    if params[:start] then
      items = Item.joins(:site).where("items.created_at >= '#{params[:start]}'").where("sites.enabled = 1").order(:created_at)
    else
      items = Item.joins(:site).where("sites.enabled = 1").order(:created_at)
    end

    sites = Site.where("sites.enabled = 1")

    render json: {sites: sites, items: items}
  end

  def update
    # パラメータが無いときにエラーにする
    if params[:items] then
      items = params[:items].split(',')
    else
      render json: error(1)
      return
    end

    result = Item.where(id: items).update_all(unread: false)
    if result then
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
