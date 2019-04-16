class Responsible::ActivitiesController < Responsible::BaseController
  # add_breadcrumb I18n.t('breadcrumbs.activities.tcc.one.index'),
  #                :responsible_activities_path
  #
  # add_breadcrumb I18n.t('breadcrumbs.activities.tcc.one.show'),
  #                :responsible_activity_path,
  #                only: [:show]
  #
  # add_breadcrumb I18n.t('breadcrumbs.activities.tcc.one.new'),
  #                :new_responsible_activity_path,
  #                only: [:new]
  #
  # add_breadcrumb I18n.t('breadcrumbs.activities.tcc.one.edit'),
  #                :edit_responsible_activity_path,
  #                only: [:edit]
  #
  def index; end

  def tcc_one
    @activities = Activity.where(tcc: Activity.tccs[:one])
                          .includes(:base_activity_type)
                          .order(:name)

    render :index
  end

  def tcc_two
    @activities = Activity.where(tcc: Activity.tccs[:two])
                          .includes(:base_activity_type)
                          .order(:name)

    render :index
  end
end
