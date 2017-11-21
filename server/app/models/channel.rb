class Channel < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  # As "presence: true" doesn't work for validate the presence of a boolean field, we must use this:
  validates :private, inclusion: { in: [true, false] }

  has_many :subscriptions
  has_many :messages
  has_many :users, through: :subscriptions
end
