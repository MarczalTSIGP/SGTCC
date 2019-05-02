class OrientationSupervisor < ApplicationRecord
  belongs_to :orientation
  belongs_to :supervisor, class_name: Professor.to_s
end
