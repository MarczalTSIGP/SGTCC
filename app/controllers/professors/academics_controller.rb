class Professors::AcademicsController < Professors::BaseController
  before_action :set_academic, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.academics.index'),
                 :professors_academics_path

  add_breadcrumb I18n.t('breadcrumbs.academics.show'),
                 :professors_academic_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.academics.new'),
                 :new_professors_academic_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.academics.edit'),
                 :edit_professors_academic_path,
                 only: [:edit]

  def index
    @academics = Academic.all
  end

  def show; end

  def new
    @academic = Academic.new
  end

  def edit; end

  def create
    @academic = Academic.new(academic_params)

    if @academic.save
      flash[:success] = I18n.t('flash.actions.create.m',
                               resource_name: Academic.model_name.human)
      redirect_to professors_academics_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @academic.update(academic_params)
      flash[:success] = I18n.t('flash.actions.update.m',
                               resource_name: Academic.model_name.human)
      redirect_to professors_academics_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    @academic.destroy
    flash[:success] = I18n.t('flash.actions.destroy.m',
                             resource_name: Academic.model_name.human)
    redirect_to professors_academics_url
  end

  private

  def set_academic
    @academic = Academic.find(params[:id])
  end

  def academic_params
    params.require(:academic).permit(:name, :email, :ra, :gender)
  end
end
