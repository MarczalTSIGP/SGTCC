module JsonMessage
  extend ActiveSupport::Concern

  def document_authenticated_message
    I18n.t('json.messages.documents.success.authenticated')
  end

  def document_not_found_message
    I18n.t('json.messages.documents.errors.not_found')
  end

  def error_document_not_found_message
    flash[:error] = document_not_found_message
  end

  def success_document_authenticated_message
    flash[:success] = document_authenticated_message
  end
end
