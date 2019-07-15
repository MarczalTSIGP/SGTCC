module OrientationAbandon
  extend ActiveSupport::Concern

  def abandon
    orientation = Orientation.find(params[:id])
    justification = params['orientation']['abandonment_justification']
    return success_abandon_json_message(orientation.status) if orientation.abandon(justification)
  end

  private

  def success_abandon_json_message(status)
    render json: {
      message: I18n.t('json.messages.orientation.cancel.success'),
      orientation: {
        status: { enum: Orientation.statuses[status], label: status }
      }
    }
  end
end
