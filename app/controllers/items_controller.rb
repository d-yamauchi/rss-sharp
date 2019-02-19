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
end
