class SiteController < ApplicationController
  layout 'layouts/site/application'

  before_action :set_post, only: :post
  before_action :set_site, only: [:sidebar, :update_sidebar]

  def index
    redirect_to action: :post, post: 'intro'
  end

  def post; end

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

  def set_post
    @post = Post.find_by(url: params[:post])
    return not_found if @post.blank?
  end
end
