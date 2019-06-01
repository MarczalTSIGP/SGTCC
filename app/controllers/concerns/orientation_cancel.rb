module OrientationCancel
  extend ActiveSupport::Concern

  def cancel
    orientation = Orientation.find(params[:id])
    orientation.cancel
    status = orientation.status

    render json: {
      message: I18n.t('json.messages.orientation.cancel.success'),
      orientation: {
        status: { enum: Orientation.statuses[status], label: status }
      }
    }
  end
end
