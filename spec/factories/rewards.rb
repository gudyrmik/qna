FactoryBot.define do

  factory :reward do
    title { "TestReward" }
    image { nil }
    association :question, factory: :question
  end

end
