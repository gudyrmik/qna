FactoryBot.define do
  factory :answer do
    user { create :user }
    question { create(:question, user_id: user.id) }
    body { FFaker::Book.description }

    trait :invalid do
      user { create :user }
      question { create(:question, user_id: user.id) }
      body { nil }
    end
  end
end
