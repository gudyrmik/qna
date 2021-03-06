FactoryBot.define do
  factory :reward do
    title { FFaker::Code.ean }
    image { nil }
    association :question, factory: :question
  end
end
