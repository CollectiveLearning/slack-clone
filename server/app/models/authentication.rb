require 'securerandom'

class Authentication
  # JSONAPI::Resources with non ActiveRecord models and service objects (guide in gem wiki)
  # howto do non-activerecord-models-in-rails-4
  include ActiveModel::Model

  attr_accessor :id, :username, :password, :token, :email, :photo_url, :exp
  attr_reader :errors

  validates :username, presence: true
  validates :password, presence: true
  # FIXME validate fails if both username and password missing, returns 201 with null token, maybe a bug in gem

  def initialize(*args)
    @errors = ActiveModel::Errors.new(self)
    @id = SecureRandom.uuid
  end

  # We need a save method in order to mimic a standard create action controller. Example above
  def save(*args)
    action = AuthenticateUser.new(username, password).call
    if action.success?
      self.assign_attributes(action.result)
      true # it can be omitted
    else
      # puts self.errors.to_json
      action.errors.each do |key, value|
        errors.add key, message: value
      end
      false
    end
  end
end

# SAMPLE
# POST /samples
# def create
#   @sample = Sample.new(sample_params)
#
#   if @sample.save
#     render json: @sample, status: :created, location: @sample
#   else
#     render json: @sample.errors, status: :unprocessable_entity
#   end
# end