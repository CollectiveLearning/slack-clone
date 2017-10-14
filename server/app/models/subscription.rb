class Subscription < ApplicationRecord
  validates :user, presence: true
  validates :channel, presence: true

  belongs_to :user
  belongs_to :channel
end
