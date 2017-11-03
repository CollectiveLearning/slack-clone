module V1
  class UserResource < BaseResource
    attribute :username

    attribute :email

    attribute :photo_url

    attribute :password

    attribute :password_confirmation

    has_many :subscriptions

    has_many :messages

    has_many :channels

    class << self
      def creatable_fields(context)
        super - [:subscriptions, :messages, :channels, :password_digest]
      end
      alias_method :updatable_fields, :creatable_fields
    end
  end
end