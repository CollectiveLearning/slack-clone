RSpec.describe User, type: :model do
  describe "Attributes" do
    it { is_expected.to have_attribute :email }
    it { is_expected.to have_attribute :username }
    it { is_expected.to have_attribute :photo_url }
    it { is_expected.to have_attribute :password_digest }
  end

  describe "Validations" do

    it "validates the uniqueness of email" do
      original = FactoryGirl.create(:user, email: "my-email@mymail.com")
      duplicate = FactoryGirl.build(:user, email: original.email)
      duplicate.valid?
      expect(duplicate.errors[:email]).to include "has already been taken"
    end

    it "validates the uniqueness of username" do
      original = FactoryGirl.create(:user, username: "my-username")
      duplicate = FactoryGirl.build(:user, username: original.username)
      duplicate.valid?
      expect(duplicate.errors[:username]).to include "has already been taken"
    end
  end

  describe "Relations" do
    pending "are missing, add examples!"
  end
end
