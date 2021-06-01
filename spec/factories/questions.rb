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

    trait :with_attachment do
      after :create do |question|
        question.files.attach({
                                io: File.open("#{Rails.root}/README.md"),
                                filename: 'README.md'
                              })
      end
    end

    trait :with_reward do
      after :create do |question|
        create(:reward, question: question)
      end
    end
  end
end
