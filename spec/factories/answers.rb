FactoryBot.define do
  factory :answer do
    user { create :user }
    question { create(:question, user_id: user.id) }
    body { FFaker::Book.description }

    trait :with_files do
      after :create do |answer|
        answer.files.attach({
                              io: File.open("#{Rails.root}/Rakefile"),
                              filename: 'Rakefile'
                            })
      end
    end

    trait :invalid do
      user { create :user }
      question { create(:question, user_id: user.id) }
      body { nil }
    end
  end
end
