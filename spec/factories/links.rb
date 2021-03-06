FactoryBot.define do
  factory :link do
    name { FFaker::Internet.user_name }
    url { FFaker::Internet.http_url }

    trait :linkable do
      association :linkable, factory: :answer
    end
  end
end
