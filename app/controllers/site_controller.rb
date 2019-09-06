class SiteController < ApplicationController
  layout 'layouts/site/application'

  before_action :set_page, only: :page
  before_action :set_site, only: [:sidebar, :update_sidebar]

  def index
    redirect_to action: :page, page: 'intro'
  end

  def page; end

  def sidebar
    render json: @site.sidebar
  end

  def update_sidebar
    render json: @site.update(sidebar: params[:data])
  end

  private

  def set_site
    @site = Site.first
  end

  def set_page
    @page = Page.find_by(url: params[:page])
    return not_found if @page.blank?
  end
end
