FactoryBot.define do
  factory :comment do
    body { "Best comment" }
    commentable { nil }
  end
end
