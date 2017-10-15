module V1
  class UserResource < BaseResource
    attribute :username

    attribute :email

    attribute :photo_url

    attribute :password_digest

    has_many :subscriptions

    has_many :messages

    has_many :channels

    class << self
      def creatable_fields(context)
        super - [:subscriptions, :messages, :channels]
      end
      alias_method :updatable_fields, :creatable_fields
    end
  end
end