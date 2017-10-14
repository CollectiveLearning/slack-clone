FactoryGirl.define do
  factory :channel do
    sequence(:name) { |n| "channel-test-#{n}" }
    description "Test channel"
    private false
  end
end
