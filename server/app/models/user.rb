class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_many :subscriptions
  has_many :messages
  has_many :channels, through: :subscriptions
end
