require 'acceptance_helper'

RSpec.resource "Messages" do

  let(:message) { FactoryGirl.create(:message) }

  get "/v1/messages" do
    parameter :page, "Current page of messages"

    let(:page) { 1 }

    before do
      5.times do |i|
        FactoryGirl.create(:message)
      end
    end

    example_request "Getting a list of messages" do
      response_data = JSON.parse(response_body)["data"]
      # puts response_body

      resp_ids = response_data.map { |message| message["id"] }

      db_ids = Message.ids.map { |id| id.to_s }

      expect(resp_ids.sort).to eq(db_ids.sort)
      expect(status).to eq(200)
    end
  end

  head "/v1/messages" do
    example_request "Getting the headers" do
      expect(response_headers["Cache-Control"]).to eq("max-age=0, private, must-revalidate")
      expect(response_headers["Content-Type"]).to eq("application/vnd.api+json")
    end
  end

  header "Content-Type", 'application/vnd.api+json'
  header "Accept", "application/vnd.api+json"

  post "/v1/messages" do

    # http://jsonapi.org/format/#crud-creating
    parameter :type, "Resource type, allways must be messages", :required => true, :scope => :data

    parameter "user", "User foreign key", :required => true, :scope => [:data, :relationships]
    parameter "channel", "Channel foreign key", :required => true, :scope => [:data, :relationships]
    parameter "content", "Message content", :scope => [:data, :attributes]
    parameter "kind", "Type of message (link, text, emoticon)", :required => true, :scope => [:data, :attributes]

    # response_field "user", "User foreign key", :scope => [:data, :relationships], "Type" => "String"
    # response_field "channel", "Channel foreign key", :scope => [:data, :relationships], "Type" => "String"

    let(:type) { "messages" }

    let!(:persisted_user) { FactoryGirl.create(:user)}
    let!(:persisted_channel) { FactoryGirl.create(:channel)}

    let(:content) { "My message"}
    let(:kind) { "text"}
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

    example_request "Creating a message" do
      # puts "params json  :"  + raw_post

      explanation "First, create a message, then make a later request to get it back"

      obj = JSON.parse(response_body)["data"]
      # puts "object  "  + obj.to_s
      # puts  JSON.parse(response_body)["data"].to_s

      expect(status).to eq(201)

      # puts "response_headers  "  + response_headers.to_s
      # puts "headers  "  + headers.to_s
      client.get(URI.parse(response_headers["location"]).path, {}, headers)
      expect(status).to eq(200)
    end
  end

  get "/v1/messages/:id" do
    let(:id) { message.id }

    example_request "Getting a specific message" do
      # puts response_body
      obj_id = JSON.parse(response_body)["data"]["id"]

      expect(obj_id).to eq(message.id.to_s)
      expect(status).to eq(200)
    end
  end

  patch "/v1/messages/:id" do

    # http://jsonapi.org/format/#crud-updating
    parameter "id", <<-DESC, required: true, :scope => :data
      The id of the message.
    DESC

    let(:id) { message.id }

    parameter :type, "Resource type, allways must be messages", :required => true, :scope => :data
    parameter "user", "User foreign key", :required => true, :scope => [:data, :relationships]
    parameter "channel", "Channel foreign key", :required => true, :scope => [:data, :relationships]
    parameter "content", "Message content", :scope => [:data, :attributes]
    parameter "kind", "Type of message (link, text, emoticon)", :required => true, :scope => [:data, :attributes]

    let(:type) { "messages" }

    let!(:persisted_user) { FactoryGirl.create(:user)}
    let!(:persisted_channel) { FactoryGirl.create(:channel)}

    let(:content) { "Changed Message"}
    let(:kind) { "link"}
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

    example_request "Updating an message" do

      # puts "request json  :"  + params.to_s
      # puts "response json  :"  + response_body
      expect(status).to eq(200)
    end
  end

  delete "/v1/messages/:id" do
    let(:id) { message.id }

    example_request "Deleting a message" do
      expect(status).to eq(204)
    end
  end
end
