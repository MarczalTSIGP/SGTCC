class Responsible::InstitutionsController < Responsible::BaseController
  before_action :set_institution, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.institutions.index'),
                 :responsible_institutions_path

  add_breadcrumb I18n.t('breadcrumbs.institutions.show'),
                 :responsible_institution_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.institutions.new'),
                 :new_responsible_institution_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.institutions.edit'),
                 :edit_responsible_institution_path,
                 only: [:edit]

  def index
    @institutions = Institution.page(params[:page]).search(params[:term])
  end

  def show; end

  def new
    @institution = Institution.new
  end

  def edit; end

  def create
    @institution = Institution.new(institution_params)

    if @institution.save
      flash[:success] = I18n.t('flash.actions.create.m',
                               resource_name: Institution.model_name.human)
      redirect_to responsible_institutions_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @institution.update(institution_params)
      flash[:success] = I18n.t('flash.actions.update.m',
                               resource_name: Institution.model_name.human)
      redirect_to responsible_institution_path(@institution)
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    @institution.destroy

    flash[:success] = I18n.t('flash.actions.destroy.m',
                             resource_name: Institution.model_name.human)

    redirect_to responsible_institutions_path
  end

  private

  def set_institution
    @institution = Institution.find(params[:id])
  end

  def institution_params
    params.require(:institution).permit(:name, :trade_name,
                                        :cnpj, :external_member_id)
  end
end
