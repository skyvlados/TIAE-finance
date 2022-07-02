class Category < ApplicationRecord
    has_many :operations
    validates :name, presence: true
end
