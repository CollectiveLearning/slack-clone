module V1
  class SubscriptionResource < BaseResource
    has_one :user

    has_one :channel

    class << self
      # Use context to set the user_id
      def create(context)
        SubscriptionResource.new(Subscription.new(user_id: context[:current_user][:id]), nil)
      end

      # It is considered good practice to ensure the user can not be passed via your API so you should also
      # update your creatable_fields method like this
      def creatable_fields(context)
        super - [:user]
      end
      alias_method :updatable_fields, :creatable_fields
    end
  end
end
