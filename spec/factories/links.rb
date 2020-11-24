FactoryBot.define do
  factory :link do
    name { "Pornhub" }
    url { 'https://www.pornhub.com/'}

    trait :linkable do
      association :linkable, factory: :answer
    end
  end
end
