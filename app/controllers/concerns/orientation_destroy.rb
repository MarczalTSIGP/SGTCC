module OrientationDestroy
  extend ActiveSupport::Concern

  def responsible_can_destroy
    can_destroy(responsible_orientations_tcc_one_path)
  end

  private

  def can_destroy(url)
    return if @orientation.can_be_destroyed?
    flash[:alert] = I18n.t('flash.orientation.destroy.signed')
    redirect_to url
  end
end
