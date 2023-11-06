class Responsible::OrientationsMigrationController < Responsible::BaseController
  include Breadcrumb

  before_action :orientations, only: [:index, :migrate]
  before_action :set_orientation, only: :migrate
  before_action :set_next_calendar, only: :migrate
  before_action :set_migration_calendar_id, only: :migrate

  def index
    add_breadcrumb I18n.t('breadcrumbs.orientations.migration'),
                   responsible_orientations_migration_path
    render :index
  end

  def migrate
    if @next_calendar
      @orientation.migrate(@new_calendar_id)
      feminine_success_update_message
      redirect_to responsible_orientations_migration_path
    else
      error_message_with(I18n.t('flash.orientation.next_calendar_not_found'))
      render :index
    end
  end

  def model_human
    I18n.t('activerecord.models.orientation.one')
  end

  private

  def set_next_calendar
    @next_calendar = Calendar.next_semester(Calendar.current_by_tcc_two)
  end

  def set_migration_calendar_id
    @new_calendar_id =
      if @orientation.current_calendar.id == Calendar.current_by_tcc_two.id
        @next_calendar.id
      else
        Calendar.current_by_tcc_two.id
      end
  end

  def orientation_params_id
    params.require(:orientation).permit(:id)
  end

  def orientations
    @orientations = Orientation.migratable(params[:page], params[:term])
  end

  def set_orientation
    @orientation = Orientation.find(orientation_params_id.fetch(:id))
  end
end
