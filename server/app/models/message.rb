class Message < ApplicationRecord
  validates :type, presence: true
  validates :user, presence: true
  validates :channel, presence: true

  belongs_to :user
  belongs_to :channel
end
