require 'active_support/concern'

module DocumentByType
  extend ActiveSupport::Concern

  included do
    def self.new_tdo(professor, params = {})
      document = DocumentType.find_by(identifier: :tdo).documents.new(params)
      new_request(professor, 'advisor', document)
    end

    def self.new_tep(academic, params = {})
      params[:orientation_id] = academic.current_orientation.id
      document = DocumentType.find_by(identifier: :tep).documents.new(params)
      new_request(academic, 'academic', document)
    end

    def self.new_tso(academic, params = {})
      params[:orientation_id] = academic.current_orientation.id
      params[:professor_supervisor_ids].shift
      params[:external_member_supervisor_ids].shift

      document = DocumentType.find_by(identifier: :tso).documents.new(params)
      new_orientation_request(academic, 'academic', document)
    end

    def self.new_orientation_request(user, user_type, document)
      document.request = { requester: document.requester_data(user, user_type),
                           new_orientation: document.new_orientation_data }
      document
    end

    def self.new_request(user, user_type, document)
      document.request = { requester: document.requester_data(user, user_type) }
      document
    end
  end
end
