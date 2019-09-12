class SiteController < ApplicationController
  layout 'layouts/site/application'

  before_action :set_page, only: :page
  before_action :set_pages, only: :index
  before_action :set_site, only: :sidebar

  def index
    if @pages.present?
      redirect_to action: :page, page: @pages.first.url
    else
      render 'site/page'
    end
  end

  def page; end

  def sidebar
    render json: Page.publisheds
  end

  private

  def set_pages
    @pages = Page.publisheds
  end

  def set_site
    @site = Site.first
  end

  def set_page
    @page = Page.find_by(url: params[:page])
    return not_found if @page.blank?
  end
end
