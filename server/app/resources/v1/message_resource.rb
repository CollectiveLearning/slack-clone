module V1
  class MessageResource < BaseResource
    attribute :content

    attribute :kind

    has_one :user

    has_one :channel

    class << self
      def create(context)
        MessageResource.new(Message.new(user_id: context[:current_user][:id]), nil)
      end

      def creatable_fields(context)
        super - [:user]
      end
      alias_method :updatable_fields, :creatable_fields
    end
  end
end