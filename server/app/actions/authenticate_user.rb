class AuthenticateUser
  prepend SimpleCommand

  def initialize(username, password)
    @username = username
    @password = password
  end

  def call
    user_attrs.merge(token: token) if user
  end

  private

  attr_accessor :username, :password, :token

  def user
    user = User.find_by(username: username)
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
  
  def user_attrs
    @user_attrs ||= user.attributes.except("created_at", "updated_at", "password_digest")
  end

  def token
    @token ||= Tokenizer::encode(user_attrs)
  end
end