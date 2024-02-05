module OrientationCancel
  extend ActiveSupport::Concern

  def cancel
    orientation = Orientation.find(params[:id])
    justification = params['orientation']['cancellation_justification']
    success_cancel_json_message(orientation.status) if orientation.cancel(justification)
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
end
