class Channel < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :private, presence: true

  has_many :subscriptions
  has_many :messages
  has_many :users, through: :subscriptions
end
