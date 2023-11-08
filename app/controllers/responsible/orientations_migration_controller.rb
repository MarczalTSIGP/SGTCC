class Responsible::OrientationsMigrationController < Responsible::BaseController
  include Breadcrumb

  before_action :orientations, only: [:index, :migrate]
  before_action :set_orientation, only: :migrate

  def index
    add_breadcrumb I18n.t('breadcrumbs.orientations.migration'),
                   responsible_orientations_migration_path
    render :index
  end

  def migrate
    if @orientation.migrate
      feminine_success_update_message
      redirect_to responsible_orientations_migration_path
    else
      flash.now[:error] = I18n.t('flash.orientation.next_calendar_not_found')
      render :index
    end
  end

  def model_human
    I18n.t('activerecord.models.orientation.one')
  end

  private

  def orientation_params_id
    params.require(:orientation).permit(:id)
  end

  def orientations
    @orientations = Orientation.to_migrate(params[:page], params[:term])
  end

  def set_orientation
    @orientation = Orientation.find(orientation_params_id.fetch(:id))
  end
end
