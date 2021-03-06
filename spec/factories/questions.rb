FactoryBot.define do
  factory :question do
    user { create :user }
    title { "Question from FactoryBot" }
    body { FFaker::Book.description }

    trait :invalid do
      user { create :user }
      title { nil }
      body { nil }
    end
  end
end
