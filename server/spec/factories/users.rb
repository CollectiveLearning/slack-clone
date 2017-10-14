FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "username-#{n}"}
    sequence(:email) { |n| "username#{n}@test.com" }
    photo_url "http://lorempixel.com/400/200/cats/"
    sequence(:password_digest) { |n| "#{n}-CRYPTIC" }
  end
end
