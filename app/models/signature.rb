class Signature < ApplicationRecord
  include KaminariHelper

  belongs_to :orientation
  belongs_to :document

  enum user_type: { professor: 'P', academic: 'A', external_member: 'E' }, _prefix: :user_type
end
