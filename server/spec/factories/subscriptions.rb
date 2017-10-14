FactoryGirl.define do
  factory :subscription do
    association :user, strategy: :build
    association :channel, strategy: :build
  end
end
