class Responsible::AcademicsController < Responsible::BaseController
  before_action :set_academic, only: [:show, :edit, :update, :destroy]
  before_action :set_resource_name, only: [:create, :update, :destroy]
  before_action :set_search_fields, only: [:index]

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
    @academics = Academic.page(params[:page]).search(params[:term], @search_fields)
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
      flash[:success] = I18n.t('flash.actions.create.m', resource_name: @resource_name)
      redirect_to responsible_academics_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @academic.update(academic_params)
      flash[:success] = I18n.t('flash.actions.update.m', resource_name: @resource_name)
      redirect_to responsible_academic_path(@academic)
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    @academic.destroy
    flash[:success] = I18n.t('flash.actions.destroy.m', resource_name: @resource_name)

    redirect_to responsible_academics_path
  end

  private

  def set_academic
    @academic = Academic.find(params[:id])
  end

  def set_resource_name
    @resource_name = Academic.model_name.human
  end

  def set_search_fields
    @search_fields = {
      name: { unaccent: true },
      email: { unaccent: false },
      ra: { unaccent: false }
    }
  end

  def academic_params
    params.require(:academic).permit(:name, :email, :ra, :gender)
  end
end
