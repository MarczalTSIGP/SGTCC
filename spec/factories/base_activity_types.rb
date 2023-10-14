FactoryBot.define do
  factory :base_activity_type do
    sequence(:name) { |n| "base_activity_type#{n}" }
    identifier { :send_document }

    factory :base_activity_type_send_document do
      identifier { :send_document }
    end

    factory :base_activity_type_info do
      identifier { :info }
    end
  end
end
