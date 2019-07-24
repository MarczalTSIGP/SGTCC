module OrientationEdit
  extend ActiveSupport::Concern

  def responsible_can_edit
    can_edit(responsible_orientations_tcc_one_path)
  end

  def professor_can_edit
    can_edit(professors_orientations_tcc_one_path)
  end

  private

  def can_edit(url)
    return if @orientation.can_be_edited?
    flash[:alert] = I18n.t('flash.orientation.edit.signed')
    redirect_to url
  end
end
