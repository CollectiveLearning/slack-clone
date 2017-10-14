FactoryGirl.define do
  factory :message do
    content "MyString"
    type "text"
    association :user, strategy: :build
    association :channel, strategy: :build
  end
end
