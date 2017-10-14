RSpec.describe Channel, type: :model do
  describe "Attributes" do
      it { is_expected.to have_attribute :name}
      it { is_expected.to have_attribute :description}
      it { is_expected.to have_attribute :private}
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :private }

    it "validates the uniqueness of name" do
      original = FactoryGirl.create(:channel)
#      original.private = true
#      original.name = "test channel"
#      original.save
#      puts original.inspect

      duplicate = FactoryGirl.build(:channel, name: original.name)
#      puts duplicate.inspect

      duplicate.valid?
      expect(duplicate.errors[:name]).to include "has already been taken"
    end
  end

  describe "Relations" do
        it { is_expected.to have_many :subscriptions }
        it { is_expected.to have_many :messages }
        it { is_expected.to have_many :users }
  end
end
