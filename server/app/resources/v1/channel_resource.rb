module V1
  class ChannelResource < BaseResource
    attribute :name

    attribute :description

    attribute :private

    has_many :subscriptions

    has_many :messages

    has_many :users

    class << self
      def creatable_fields(context)
        super - [:subscriptions, :messages, :users]
      end
      alias_method :updatable_fields, :creatable_fields
    end
  end
end
