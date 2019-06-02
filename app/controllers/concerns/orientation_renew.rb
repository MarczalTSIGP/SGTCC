module OrientationRenew
  extend ActiveSupport::Concern

  def renew
    orientation_renewed = orientation.renew(justification)

    if orientation_renewed
      success_json_message(orientation_renewed)
    else
      error_json_message
    end
  end

  private

  def success_json_message(orientation)
    render json: {
      message: I18n.t('json.messages.orientation.renew.save'),
      status: { enum: 'RENEWED', label: orientation.status }
    }
  end

  def error_json_message
    message = I18n.t('json.messages.orientation.calendar.errors.empty_next_semester')
    render json: { message: message, status: :not_found }
  end

  def justification
    params['orientation']['renewal_justification']
  end

  def orientation
    Orientation.find(params[:id])
  end
end
