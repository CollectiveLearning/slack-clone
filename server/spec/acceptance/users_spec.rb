require 'acceptance_helper'

RSpec.resource "Users" do

  let(:user) { FactoryGirl.create(:user) }

  get "/v1/users" do
    parameter :page, "Current page of users"

    let(:page) { 1 }

    before do
      5.times do |i|
        FactoryGirl.create(:user)
      end
    end

    example_request "Getting a list of users" do
      response_data = JSON.parse(response_body)["data"]
      resp_ids = response_data.map { |user| user["id"] }

      db_ids = User.select(:id).all.map { |user| user["id"].to_s }

      expect(resp_ids.sort).to eq(db_ids.sort)
      expect(status).to eq(200)
    end
  end

  head "/v1/users" do
    example_request "Getting the headers" do
      expect(response_headers["Cache-Control"]).to eq("max-age=0, private, must-revalidate")
      expect(response_headers["Content-Type"]).to eq("application/vnd.api+json")
    end
  end

  header "Content-Type", 'application/vnd.api+json'
  header "Accept", "application/vnd.api+json"

  post "/v1/users" do

    # http://jsonapi.org/format/#crud-creating
    parameter :type, "Resource type, allways be users", :required => true, :scope => :data

    parameter "username", 'Application user identifier', :required => true, :scope => [:data, :attributes]
    parameter "email", "User email", :required => true, :scope => [:data, :attributes]
    parameter "photo-url", "URL for user avatar", :required => false, :scope => [:data, :attributes]
    parameter "password-digest", "Encoded user password", :required => true, :scope => [:data, :attributes]

    response_field "username", "Application user identifier", :scope => :attributes, "Type" => "String"
    response_field "email", "User email", :scope => :attributes, "Type" => "String"
    response_field "photo-url", "URL for user avatar", :scope => :attributes, "Type" => "String"
    response_field "password-digest", "Encoded user password", :scope => :attributes, "Type" => "String"

    let(:type) { "users" }

    let(:username) { "palvarado" }
    let(:email) { "palvarado@example.com" }
    let("photo-url") { "http://pixels.example.com/palvarado" }
    let("password-digest") { "encodedpassword" }

    let(:raw_post) { params.to_json }

    example_request "Creating an user" do
      # puts "params json  :"  + raw_post

      explanation "First, create an user, then make a later request to get it back"

      obj = JSON.parse(response_body)["data"]["attributes"]

      # puts "object  "  + obj.to_s
      expect(obj["username"]).to eq(username)
      expect(obj["email"]).to eq(email)
      expect(obj["photo-url"]).to eq public_send("photo-url")
      expect(status).to eq(201)

      # puts "response_headers  "  + response_headers.to_s
      # puts "headers  "  + headers.to_s
      client.get(URI.parse(response_headers["location"]).path, {}, headers)
      expect(status).to eq(200)
    end
  end

  get "/v1/users/:id" do
    let(:id) { user.id }

    example_request "Getting a specific user" do
      obj = JSON.parse(response_body)["data"]["attributes"]

      # comparing hashes doesn't work:
      # expect(obj).to eq(user.attributes.slice("username", "email", "photo_url", "password_digest"))
      expect(obj["username"]).to eq(user.username)
      expect(obj["email"]).to eq(user.email)
      expect(obj["photo-url"]).to eq user.photo_url

      expect(status).to eq(200)
    end
  end

  patch "/v1/users/:id" do

    # http://jsonapi.org/format/#crud-updating
    parameter :type, "Resource type, allways be users", :required => true, :scope => :data
    parameter "username", 'Application user identifier', :required => true, :scope => [:data, :attributes]
    parameter "email", "User email", :required => true, :scope => [:data, :attributes]
    parameter "photo-url", "URL for user avatar", :required => false, :scope => [:data, :attributes]

    parameter "id", <<-DESC, required: true, :scope => :data
      The id of the user.
    DESC

    let(:type) { "users" }
    let(:id) { user.id }
    let(:username) { "Updated username" }
    let(:email) { "updatedemail@sample.com" }

    let(:raw_post) { params.to_json }

    example_request "Updating an user" do

      # puts "request json  :"  + params.to_s
      # puts "response json  :"  + response_body
      expect(status).to eq(200)
    end
  end

  delete "v1/users/:id" do
    let(:id) { user.id }

    example_request "Deleting an user" do
      expect(status).to eq(204)
    end
  end
end
