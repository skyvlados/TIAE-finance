class Operation < ApplicationRecord
    belongs_to :category
    validates :categories_type, presence: true
    validates :category_id, presence: true
    validates :date, presence: true
    validates :amount, presence: true
    validates :currency, presence: true
end
