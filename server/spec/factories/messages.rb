FactoryGirl.define do
  factory :message do
    sequence(:content) { |n| "This is message-#{n}"}
    kind "text"
    association :channel, strategy: :build
    association :user, strategy: :build
  end
end
