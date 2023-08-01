# https://gist.github.com/ReganRyanNZ/71e4128d34459d5b00dcb27d2ba1757e
module FactoryBotEnhancements
  def change_factory_to_find_or_create
    # Note that this will ignore nil value attributes,
    # to avoid auto-generated attributes such as id and timestamps
    to_create do |instance|
      attributes = instance.class.find_or_create_by(instance.attributes.compact).attributes
      instance.attributes = attributes.except('id')
      instance.id = attributes['id'] # id can't be mass-assigned
      instance.instance_variable_set('@new_record', false) # marks record as persisted
      instance.reload
    end
  end
end
