class Operation < ApplicationRecord
  belongs_to :category

  enum direction: { income: 1, expenditure: 2 }
  enum currency: { RUB: 1, USD: 2, EUR: 3 }

  validates :category_id, presence: true
  validates :direction, presence: true
  validates :date, presence: true
  validates :amount, presence: true
  validates :currency, presence: true
end
