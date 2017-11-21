module V1
  class AuthenticationResource < BaseResource
    model_name 'Authentication'

    key_type :uuid
    paginator :none # prevents offset and limit from being called

    attributes :username, :password, :token, :email, :photo_url, :exp
    puts "model_name"
    puts self

    class << self
      def creatable_fields(context)
        # puts context
        super - [:id, :token]
      end
    end

    def fetchable_fields
      super - [:password] + [:email, :photo_url, :exp, :token]
    end
  end
end
