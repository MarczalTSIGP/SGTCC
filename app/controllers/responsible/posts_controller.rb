class Responsible::PostsController < Responsible::BaseController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.posts.index'),
                 :responsible_posts_path

  add_breadcrumb I18n.t('breadcrumbs.posts.show'),
                 :responsible_post_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.posts.new'),
                 :new_responsible_post_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.posts.edit'),
                 :edit_responsible_post_path,
                 only: [:edit]

  def index
    @posts = Post.page(params[:page]).search(params[:term])
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = Post.new(post_params)

    if @post.save
      success_create_message
      redirect_to responsible_posts_path
    else
      error_message
      render :new
    end
  end

  def update
    if @post.update(post_params)
      success_update_message
      redirect_to responsible_post_path(@post)
    else
      error_message
      render :edit
    end
  end

  def destroy
    @post.destroy
    success_destroy_message

    redirect_to responsible_posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
