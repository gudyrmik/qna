FactoryBot.define do
  factory :question do
    title { "Question from #{FFaker::Name.name}" }
    body { FFaker::Book.description }

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
