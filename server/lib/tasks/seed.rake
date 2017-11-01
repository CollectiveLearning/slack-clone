namespace :db do
  namespace :seed do
    desc "Load examples for user model"
    task :users => :environment do
      YAML.load_file(Rails.root.join("db","seeds","users.yml")).each do |attributes|
        User.new(attributes).save
      end
    end
  end
end

