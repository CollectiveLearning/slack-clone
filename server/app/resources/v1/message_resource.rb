module V1
  class MessageResource < BaseResource
    attribute :content

    attribute :type

    has_one :user

    has_one :channel

    class << self
      def creatable_fields(context)
        super
      end
      alias_method :updatable_fields, :creatable_fields
    end
  end
end