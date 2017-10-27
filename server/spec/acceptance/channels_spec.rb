require 'acceptance_helper'

RSpec.resource "Channels" do

  let(:channel) { FactoryGirl.create(:channel) }

  get "/v1/channels" do
    parameter :page, "Current page of channels"

    let(:page) { 1 }

    before do
      5.times do |i|
        FactoryGirl.create(:channel)
      end
    end

    example_request "Getting a list of channels" do
      response_data = JSON.parse(response_body)["data"]
      resp_ids = response_data.map { |channel| channel["id"] }

      db_ids = Channel.select(:id).all.map { |channel| channel["id"].to_s }

      expect(resp_ids.sort).to eq(db_ids.sort)
      expect(status).to eq(200)
    end
  end

  head "/v1/channels" do
    example_request "Getting the headers" do
      expect(response_headers["Cache-Control"]).to eq("max-age=0, private, must-revalidate")
      expect(response_headers["Content-Type"]).to eq("application/vnd.api+json")
    end
  end

  header "Content-Type", 'application/vnd.api+json'
  header "Accept", "application/vnd.api+json"

  post "/v1/channels" do

    # http://jsonapi.org/format/#crud-creating
    parameter :type, "Resource type, allways be channels", :required => true, :scope => :data

    parameter "name", 'Application channel name', :required => true, :scope => [:data, :attributes]
    parameter "description", "Channel description", :scope => [:data, :attributes]
    parameter "private", "Boolean indicates if is a private channel, default value false", :scope => [:data, :attributes]

    response_field "name", 'Application channel name', :scope => [:data, :attributes], "Type" => "String"
    response_field "description", "Channel description", :scope => [:data, :attributes], "Type" => "String"
    response_field "private", "Boolean indicates if is a private channel, default value false", :scope => [:data, :attributes], "Type" => "Boolean"

    let(:type) { "channels" }

    let(:name) { "General" }
    let(:description) { "Open for any kind of topics" }
    let("private") { true }

    let(:raw_post) { params.to_json }

    example_request "Creating an channel" do
      explanation "First, create an channel, then make a later request to get it back"

      obj = JSON.parse(response_body)["data"]["attributes"]
      expect(obj["name"]).to eq(name)
      expect(obj["description"]).to eq(description)
      expect(obj["private"]).to eq public_send("private")
      expect(status).to eq(201)

      client.get(URI.parse(response_headers["location"]).path, {}, headers)
      expect(status).to eq(200)
    end
  end

  get "/v1/channels/:id" do
    let(:id) { channel.id }

    example_request "Getting a specific channel" do
      obj = JSON.parse(response_body)["data"]["attributes"]

      # comparing hashes doesn't work:
      # expect(obj).to eq(channel.attributes.slice("name", "private", "description"))
      expect(obj["name"]).to eq(channel.name)
      expect(obj["private"]).to eq(channel.private)
      expect(obj["description"]).to eq channel.description

      expect(status).to eq(200)
    end
  end

  patch "/v1/channels/:id" do

    # http://jsonapi.org/format/#crud-updating
    parameter :type, "Resource type, allways be channels", :required => true, :scope => :data
    parameter "name", 'Application channel name', :required => true, :scope => [:data, :attributes]
    parameter "description", "Channel description", :scope => [:data, :attributes]
    parameter "private", "Boolean indicates if is a private channel, default value false", :scope => [:data, :attributes]

    parameter "id", <<-DESC, required: true, :scope => :data
      The id of the channel.
    DESC

    let(:type) { "channels" }
    let(:id) { channel.id }
    let(:name) { "Updated name" }
    let(:private) { true }
    let(:description) { "Open for any kind of topics" }

    let(:raw_post) { params.to_json }

    example_request "Updating a channel" do

      # puts "request json  :"  + params.to_s
      # puts "response json  :"  + response_body
      expect(status).to eq(200)
    end
  end

  delete "v1/channels/:id" do
    let(:id) { channel.id }

    example_request "Deleting a channel" do
      expect(status).to eq(204)
    end
  end
end
