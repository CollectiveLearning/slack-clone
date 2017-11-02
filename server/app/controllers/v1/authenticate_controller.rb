module V1
  class AuthenticateController < ApplicationController
    # skip_before_action :authenticate_request

    def login
      # params.require(:authenticate).permit(:username, :password)
      action = AuthenticateUser.new(params[:username], params[:password]).call

      if action.success?
        render json: action.result
      else
        render json: { error: action.errors }, status: :unauthorized
      end
    end

    private

    def serialized_response
      # TODO...
    end
  end
end
