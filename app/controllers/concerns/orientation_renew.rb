module OrientationRenew
  extend ActiveSupport::Concern

  def renew
    orientation_renewed = orientation.renew(params['orientation']['renewal_justification'])
    return success_renew_json_message(orientation_renewed) if orientation_renewed
    error_renew_json_message
  end

  private

  def success_renew_json_message(orientation)
    render json: {
      message: I18n.t('json.messages.orientation.renew.save'),
      orientation: {
        status: { enum: Orientation.statuses[orientation.status], label: orientation.status }
      }
    }
  end

  def error_renew_json_message
    message = I18n.t('json.messages.orientation.calendar.errors.empty_next_semester')
    render json: { message: message, status: :not_found }
  end

  def orientation
    Orientation.find(params[:id])
  end
end
