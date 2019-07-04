require 'active_support/concern'

module SignatureStatus
  extend ActiveSupport::Concern

  included do
    def signatures_status
      signatures.map do |signature|
        { name: signature.user_table.find(signature.user_id).name, status: signature.status }
      end
    end
  end
end
