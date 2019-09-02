class SiteController < ApplicationController
  before_action :set_post, only: :post

  def index
    redirect_to action: :post, post: 'intro'
  end

  def post; end

  private

  def set_post
    @post = Post.find_by(url: params[:post])
    return if @post.present?
    flash[:alert] = I18n.t('flash.not_found_page')
    redirect_to root_path
  end
end
