module OrientationCancel
  extend ActiveSupport::Concern

  def cancel
    justification = params['orientation']['cancellation_justification']
    return success_cancel_json_message(orientation.status) if orientation.cancel(justification)
    error_cancel_json_message
  end

  private

  def success_cancel_json_message(status)
    render json: {
      message: I18n.t('json.messages.orientation.cancel.success'),
      orientation: {
        status: { enum: Orientation.statuses[status], label: status }
      }
    }
  end

  def error_cancel_json_message
    message = I18n.t('json.messages.orientation.cancel.error')
    render json: { message: message, status: :internal_server_error }
  end

  def orientation
    Orientation.find(params[:id])
  end
end
