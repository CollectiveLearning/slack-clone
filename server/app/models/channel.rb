class Channel < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :private, presence: true
end
