class Responsible::AcademicsController < Responsible::BaseController
  before_action :set_academic, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.academics.index'),
                 :responsible_academics_path

  add_breadcrumb I18n.t('breadcrumbs.academics.show'),
                 :responsible_academic_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.academics.new'),
                 :new_responsible_academic_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.academics.edit'),
                 :edit_responsible_academic_path,
                 only: [:edit]

  def index
    @academics = Academic.page(params[:page]).search(params[:term]).order(:name)
  end

  def show; end

  def new
    @academic = Academic.new
  end

  def edit; end

  def create
    @academic = Academic.new(academic_params)
    @academic.define_singleton_method(:password_required?) { false }

    if @academic.save
      success_create_message
      redirect_to responsible_academics_path
    else
      error_message
      render :new
    end
  end

  def update
    if @academic.update(academic_params)
      success_update_message
      redirect_to responsible_academic_path(@academic)
    else
      error_message
      render :edit
    end
  end

  def destroy
    @academic.destroy
    success_destroy_message

    redirect_to responsible_academics_path
  end

  private

  def set_academic
    @academic = Academic.find(params[:id])
  end

  def academic_params
    params.require(:academic).permit(:name, :email, :ra, :gender)
  end
end
