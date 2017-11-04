class ApplicationController < JSONAPI::ResourceController
  protect_from_forgery with: :null_session

  before_action :validate_request_token

  # http://jsonapi-resources.com/v0.10/guide/resources.html#Context
  def context
    {current_user: current_user}
  end

  private

  # helper_method :current_user
  attr_reader :current_user

  def validate_request_token

    # request.headers["Authorization"]  is the same as request.authorization
    action = ValidateRequestToken.call(request.authorization)
    if action.success?
      @current_user = action.result
    else
      render json: { errors: action.errors }, status: 401
    end
  end

end