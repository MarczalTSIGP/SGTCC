module OrientationRenew
  extend ActiveSupport::Concern

  def renew
    if next_calendar.blank?
      next_calendar_not_found
    elsif orientation.status == 'IN_PROGRESS'
      save
    end
  end

  def next_calendar_not_found
    msg = I18n.t('json.messages.orientation.calendar.errors.empty_next_semester')
    render json: { message: msg, status: :not_found }
  end

  def save
    new_orientation = orientation.renew(justification, next_calendar)
    status = new_orientation.status
    render json: {
      message: I18n.t('json.messages.orientation.renew.save'),
      status: { label: Orientation.statuses[status], enum: status }
    }
  end

  private

  def justification
    params['orientation']['renewal_justification']
  end

  def orientation
    Orientation.find(params[:id])
  end

  def next_calendar
    Calendar.next_semester(orientation.calendar)
  end
end
