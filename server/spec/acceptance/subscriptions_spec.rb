require 'acceptance_helper'

RSpec.resource "Subscriptions" do
  let (:password) { "my-password" }
  let(:token_user) { FactoryGirl.create(:user, password: password, password_confirmation: password) }
  let(:mytoken) { AuthenticateUser.new(token_user.username, password).call.result[:token] }

  let(:subscription) { FactoryGirl.create(:subscription) }

  get "/v1/subscriptions" do
    parameter :page, "Current page of subscriptions"

    let(:page) { 1 }

    before do
      5.times do |i|
        FactoryGirl.create(:subscription)
      end
      header 'Authorization', mytoken
    end

    example_request "Getting a list of subscriptions" do
      response_data = JSON.parse(response_body)["data"]
      resp_ids = response_data.map { |subscription| subscription["id"] }

      db_ids = Subscription.ids.map { |id| id.to_s }

      expect(resp_ids.sort).to eq(db_ids.sort)
      expect(status).to eq(200)
    end
  end

  head "/v1/subscriptions" do
    before do
      header 'Authorization', mytoken
    end

    example_request "Getting the headers" do
      expect(response_headers["Cache-Control"]).to eq("max-age=0, private, must-revalidate")
      expect(response_headers["Content-Type"]).to eq("application/vnd.api+json")
    end
  end

  header "Content-Type", 'application/vnd.api+json'
  header "Accept", "application/vnd.api+json"

  post "/v1/subscriptions" do
    before do
      header 'Authorization', mytoken
    end

    # http://jsonapi.org/format/#crud-creating
    parameter :type, "Resource type, allways must be subscriptions", :required => true, :scope => :data

    parameter "user", "User foreign key", :required => true, :scope => [:data, :relationships]
    parameter "channel", "Channel foreign key", :required => true, :scope => [:data, :relationships]

    response_field "user", "User foreign key", :scope => [:data, :relationships], "Type" => "String"
    response_field "channel", "Channel foreign key", :scope => [:data, :relationships], "Type" => "String"


    let(:type) { "subscriptions" }

    let!(:persisted_user) { FactoryGirl.create(:user)}
    let!(:persisted_channel) { FactoryGirl.create(:channel)}

    let "channel" do
      {
          data: {
              type: "channels",
              id: persisted_channel.id.to_s
          }
      }
    end

    let "user" do
      {
          data: {
              type: "users",
              id: persisted_user.id.to_s
          }
      }
    end
    let(:raw_post) { params.to_json }

    example_request "Creating a subscription" do
      # puts "params json  :"  + raw_post

      explanation "First, create an subscription, then make a later request to get it back"

      # obj = JSON.parse(response_body)["data"]["relationships"]
      # puts "object  "  + obj.to_s
      # puts  JSON.parse(response_body)["data"].to_s

      expect(status).to eq(201)

      # puts "headers  "  + headers.to_s
      # puts URI.parse(response_headers["location"]).path

      client.get(URI.parse(response_headers["location"]).path, {}, headers)
      expect(status).to eq(200)

      # puts "response_headers  "  + response_headers.to_s
      # puts "body  "  + response_body
      subscription_user_url = JSON.parse(response_body)["data"]["relationships"]["user"]["links"]["related"]

      client.get(subscription_user_url, {}, headers)
      expected_user_id = JSON.parse(response_body)["data"]["id"].to_s
      # puts expected_user_id
      # puts user[:data][:id]

      expect(expected_user_id).to eq(user[:data][:id])

      expect(status).to eq(200)
    end
  end

  get "/v1/subscriptions/:id" do
    before do
      header 'Authorization', mytoken
    end

    let(:id) { subscription.id }

    example_request "Getting a specific subscription" do
      # puts response_body
      obj_id = JSON.parse(response_body)["data"]["id"]

      expect(obj_id).to eq(subscription.id.to_s)
      expect(status).to eq(200)
    end
  end

  patch "/v1/subscriptions/:id" do
    before do
      header 'Authorization', mytoken
    end

    # http://jsonapi.org/format/#crud-updating
    parameter :type, "Resource type, allways be subscriptions", :required => true, :scope => :data

    parameter "id", <<-DESC, required: true, :scope => :data
      The id of the subscription.
    DESC

    let(:id) { subscription.id }

    parameter "user", "User foreign key", :required => true, :scope => [:data, :relationships]
    parameter "channel", "Channel foreign key", :required => true, :scope => [:data, :relationships]

    response_field "user", "User foreign key", :scope => [:data, :relationships], "Type" => "String"
    response_field "channel", "Channel foreign key", :scope => [:data, :relationships], "Type" => "String"

    let(:type) { "subscriptions" }

    let!(:persisted_user) { FactoryGirl.create(:user)}
    let!(:persisted_channel) { FactoryGirl.create(:channel)}

    let "channel" do
      {
          data: {
              type: "channels",
              id: persisted_channel.id.to_s
          }
      }
    end

    let "user" do
      {
          data: {
              type: "users",
              id: persisted_user.id.to_s
          }
      }
    end
    let(:raw_post) { params.to_json }

    example_request "Updating an subscription" do

      # puts "request json  :"  + params.to_s
      # puts "response json  :"  + response_body
      expect(status).to eq(200)
    end
  end

  delete "/v1/subscriptions/:id" do
    before do
      header 'Authorization', mytoken
    end
    let(:id) { subscription.id }

    example_request "Deleting a subscription" do
      expect(status).to eq(204)
    end
  end
end
