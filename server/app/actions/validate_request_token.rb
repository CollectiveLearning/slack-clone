class ValidateRequestToken
  prepend SimpleCommand

  def initialize(token = nil)
    @token = token
    errors.add :token, 'Missing token' unless @token
  end

  def call
    user_attrs
  end

  private

  attr_reader :token

  def user_attrs
    if token
      @user_attrs ||= decoded_token
      @user_attrs || errors.add(:token, 'Invalid token') && nil
    end
  end

  def decoded_token
    @decoded_token ||= Tokenizer.decode(token)
  end
end