module OrientationCancel
  extend ActiveSupport::Concern

  def cancel
    orientation = Orientation.find(params[:id])
    justification = params['orientation']['cancellation_justification']

    return unless orientation.cancel(justification)

    respond_to do |format|
      format.html { handle_html_response(orientation) }
      format.json { handle_json_response(orientation) }
    end
  end

  private

  def handle_html_response(orientation)
    flash[:success] = I18n.t('json.messages.orientation.cancel.success')
    redirect_to responsible_orientation_path(orientation)
  end

  def handle_json_response(orientation)
    render json: {
      message: I18n.t('json.messages.orientation.cancel.success'),
      orientation: { status: orientation_status(orientation) }
    }
  end

  def orientation_status(orientation)
    { enum: Orientation.statuses[orientation.status], label: orientation.status }
  end
end
