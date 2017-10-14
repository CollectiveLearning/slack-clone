require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "Attributes" do
    #[:content, :type].each do |attr|
    %i(content type channel_id user_id).each do |attr|
      it { is_expected.to have_attribute attr }
    end
  end

  describe "Validations" do
    %i(user channel type).each do |attr|
      it { is_expected.to validate_presence_of attr }
    end
  end

  describe "Relations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :channel }
  end
end
