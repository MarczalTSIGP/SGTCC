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
    @institutions = Institution.page(params[:page])
                               .search(params[:term])
                               .order(:trade_name)
                               .includes(:external_member)
  end

  def show; end

  def new
    @institution = Institution.new
  end

  def edit; end

  def create
    @institution = Institution.new(institution_params)

    if @institution.save
      feminine_success_create_message
      redirect_to responsible_institutions_path
    else
      error_message
      render :new
    end
  end

  def update
    if @institution.update(institution_params)
      feminine_success_update_message
      redirect_to responsible_institution_path(@institution)
    else
      error_message
      render :edit
    end
  end

  def destroy
    @institution.destroy
    feminine_success_destroy_message

    redirect_to responsible_institutions_path
  end

  private

  def set_institution
    @institution = Institution.find(params[:id])
  end

  def institution_params
    params.require(:institution).permit(:name, :trade_name, :working_area,
                                        :cnpj, :external_member_id)
  end
end
