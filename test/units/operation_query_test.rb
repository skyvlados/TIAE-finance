# frozen_string_literal: true

require 'test_helper'
class OperationQueryTest < ActiveSupport::TestCase
  test 'by direction' do
    assert_equal OperationQuery.new(direction: 'income').call.ids, [operations(:salary).id]
  end

  test 'by category' do
    assert_equal OperationQuery.new(category: Category.find_by(name: 'relax').id).call.to_a, [operations(:relax)]
  end

  test 'by currency' do
    assert_equal OperationQuery.new(currency: 'EUR').call.to_a, [operations(:food)]
  end

  test 'by date start' do
    assert_equal OperationQuery.new(date_start: '2020-01-05').call.order(date: :desc).to_a,
                 operations(:food, :relax, :each_goods, :goods)
  end

  test 'by date finish' do
    assert_equal OperationQuery.new(date_finish: '2020-01-05').call.order(date: :desc).to_a, operations(:goods, :salary)
  end

  test 'by direction, category, currency, date' do
    assert_equal OperationQuery
      .new(direction: 'expenditure', currency: 'RUB',
           category: Category.find_by(name: 'goods').id, date_start: '2020-01-05',
           date_finish: '2020-01-05').call.order(date: :desc)
      .to_a,
                 [operations(:goods)]
  end
end
