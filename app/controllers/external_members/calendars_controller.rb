class ExternalMembers::CalendarsController < ExternalMembers::BaseController
  add_breadcrumb I18n.t('breadcrumbs.calendars.index'),
                 :external_members_calendars_path

  def index
    orientations = current_external_member.supervisions.with_relationships.recent
    @orientations = ExternalMember.paginate_array(orientations, params[:page])
  end
end
