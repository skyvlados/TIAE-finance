# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'should not save category without name' do
    category = Category.new
    assert_not category.save
  end

  test 'should save category' do
    category = Category.new(name: 'Test name')
    assert category.save
  end

  test 'should not edit category' do
    category = Category.create(name: 'Test name')
    assert_not category.update(name: '')
  end

  test 'should edit category' do
    category = Category.create(name: 'Test name')
    assert category.update(name: 'Test name2')
  end

  test 'should not delete category' do
    category = Category.create(name: 'Test name')
    Operation.create(direction: 1, category: category, date: '2021-01-01', amount: 100, currency: 1,
                     user: users(:test3))
    assert_raises(ActiveRecord::InvalidForeignKey) { category.destroy }
  end

  test 'should delete category' do
    category = Category.create(name: 'Test name')
    assert category.destroy
  end
end
