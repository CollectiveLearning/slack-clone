module Tokenizer
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i

      # secret_key_base is stored on config/secrets.yml
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]

      # Implements a hash where keys <tt>:foo</tt> and <tt>"foo"</tt> are considered
      # to be the same.
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end