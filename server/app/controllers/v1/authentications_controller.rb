module V1
  class AuthenticationsController < ApplicationController
    skip_before_action :validate_request_token, only: [:create]
  end
end
