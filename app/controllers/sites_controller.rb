class SitesController < ApplicationController
  def index
    sites = Site.where("enabled = 1")

    render json: sites
  end
end
