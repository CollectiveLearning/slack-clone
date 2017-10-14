namespace :db do
  namespace :seed do
    desc "Load examples for user model"
    task :users => :environment do
      YAML.load_file(Rails.root.join("db","seeds","users.yml")).each do |attributes|
        User.find_or_create_by!(attributes)
      end
    end
  end
end

