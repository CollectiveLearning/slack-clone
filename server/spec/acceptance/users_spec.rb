require 'acceptance_helper'

RSpec.resource "Users" do
  get "/v1/users" do
    example "Listing orders" do
      do_request

      expect(status).to eq(200)
    end
  end
end
