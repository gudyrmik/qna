FactoryBot.define do
  factory :question do
    user { create :user }
    title { "Question from #{user.email}" }
    body { FFaker::Book.description }

    trait :invalid do
      user
      title { nil }
      body { nil }
    end
  end
end
