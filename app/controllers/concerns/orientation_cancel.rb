module OrientationCancel
  extend ActiveSupport::Concern

  def cancel
    if orientation.cancel(justification)
      success_json_message(orientation.status)
    else
      error_json_message
    end
  end

  private

  def success_json_message(status)
    render json: {
      message: I18n.t('json.messages.orientation.cancel.success'),
      orientation: {
        status: { enum: Orientation.statuses[status], label: status }
      }
    }
  end

  def error_json_message
    message = I18n.t('json.messages.orientation.cancel.error')
    render json: { message: message, status: :internal_server_error }
  end

  def justification
    params['orientation']['cancellation_justification']
  end

  def orientation
    Orientation.find(params[:id])
  end
end
