FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    author { "user1@test.com" }

    trait :invalid do
      title { nil }
    end
  end
end
