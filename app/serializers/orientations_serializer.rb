class OrientationsSerializer
  include JSONAPI::Serializer

  attribute :academic do |object|
    {
      name: object.academic.name
    }
  end

  attribute :advisor do |object|
    {
      name: object.advisor.name_with_scholarity
    }
  end

  attribute :supervisors do |object|
    {
      size: object.supervisors.count,
      names: object.supervisors.map(&:name_with_scholarity).join(', ')
    }
  end

  attribute :title, &:title

  attribute :summary do |_object|
    ''
  end

  attribute :approved_date do |_object|
    ''
  end

  attribute :documents do |_object|
    []
  end

  def self.approved_date(object, identifier)
    date = object.examination_boards.find_by(identifier: identifier, situation: :approved).date
    I18n.l(date, format: :long)
  end
end
