class Academics::OrientationsController < Academics::BaseController
  before_action :set_calendar
  before_action :set_orientation, only: [:document, :documents]
  before_action :set_document, only: :document
  before_action :set_signature, only: :document

  add_breadcrumb I18n.t('breadcrumbs.calendars.index'),
                 :academics_calendars_path

  def documents
    set_document_orientation_breadcrumb
    @documents = @orientation.documents.with_relationships.page(params[:page])
  end

  def document
    params_url = { calendar_id: @calendar, id: @orientation, document_id: @document }

    set_document_orientation_breadcrumb
    add_breadcrumb I18n.t('breadcrumbs.documents.show'),
                   academics_calendar_orientation_document_path(params_url)
  end

  private

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_orientation
    @orientation = @calendar.orientations.find(params[:id])
  end

  def set_document
    @document = @orientation.documents.find(params[:document_id])
  end

  def set_signature
    @signature = @document.signature_by_user(current_academic.id, :academic)
  end

  def set_document_orientation_breadcrumb
    add_breadcrumb I18n.t('breadcrumbs.documents.orientation'),
                   academics_calendar_orientation_documents_path(@calendar, @orientation)
  end
end
