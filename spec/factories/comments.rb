FactoryBot.define do
  factory :comment do
    body { "Best comment" }
    commentable { nil }
    user { create(:user) }
  end
end
