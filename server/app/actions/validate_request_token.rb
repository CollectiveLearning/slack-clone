class ValidateRequestToken
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user_attrs
  end

  private

  attr_reader :headers

  def user_attrs
    @user_attrs ||= decoded_token
    @user_attrs || errors.add(:token, 'Invalid token') && nil
  end

  def decoded_token
    @decoded_token ||= Tokenizer.decode(authorization_header) if authorization_header
  end

  def authorization_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add :token, 'Missing token'
    end
    nil
  end
end