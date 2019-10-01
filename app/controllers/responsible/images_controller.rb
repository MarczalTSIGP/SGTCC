class Responsible::ImagesController < Responsible::BaseController
  before_action :set_image, only: [:edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.images.index'),
                 :responsible_images_path

  add_breadcrumb I18n.t('breadcrumbs.images.show'),
                 :responsible_image_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.images.new'),
                 :new_responsible_image_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.images.edit'),
                 :edit_responsible_image_path,
                 only: [:edit]

  def index
    @images = Image.page(params[:page]).search(params[:term]).order(created_at: :desc)
  end

  def new
    @image = Image.new
  end

  def edit; end

  def create
    @image = Image.new(image_params)

    if @image.save
      feminine_success_create_message
      redirect_to responsible_images_path
    else
      error_message
      render :new
    end
  end

  def update
    if @image.update(image_params)
      feminine_success_update_message
      redirect_to responsible_images_path
    else
      error_message
      render :edit
    end
  end

  def destroy
    @image.destroy
    feminine_success_destroy_message

    redirect_to responsible_images_path
  end

  private

  def set_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:name, :url, :url_cache)
  end
end
