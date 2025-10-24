module OrientationCancel
  extend ActiveSupport::Concern

  def cancel
    orientation = Orientation.find(params[:id])
    justification = params['orientation']['cancellation_justification']
    
    if orientation.cancel(justification)
      respond_to do |format|
        format.html do
          flash[:success] = I18n.t('json.messages.orientation.cancel.success')
          redirect_to responsible_orientation_path(orientation)
        end
        format.json do
          render json: {
            message: I18n.t('json.messages.orientation.cancel.success'),
            orientation: {
              status: { enum: Orientation.statuses[orientation.status], label: orientation.status }
            }
          }
        end
      end
    end
  end
end
