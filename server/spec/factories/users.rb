FactoryGirl.define do
  factory :user do
    username "Pedro Alvarado"
    sequence(:email) { |n| "test-#{n}@test.com" }
    photo_url "http://lorempixel.com/400/200/cats/"
    password_digest "mUc3m00RsqyRe"
  end
end
