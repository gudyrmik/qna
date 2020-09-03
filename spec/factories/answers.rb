FactoryBot.define do
  factory :answer do
    question { 1 }
    body { "MyText" }

    trait :invalid do
      body { nil }
    end
  end
end
