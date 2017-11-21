FactoryGirl.define do
  factory :channel do
    sequence(:name) { |n| "channel-test-#{n}" }
    sequence(:description) { |n| "Test channel #{n}" }
    private true
  end
end
