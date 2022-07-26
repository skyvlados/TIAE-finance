# frozen_string_literal: true

require 'test_helper'

class OperationsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get operations_path
    assert_response :success
  end

  test 'should get show' do
    Category.create(name: 'Test name')
    test_category_id = Category.find_by(name: 'Test name').id
    Operation.create(category_id: test_category_id, direction: 'income', date: '2020-01-01', amount: 100,
                     currency: 'RUB')
    test_operation_id = Operation.find_by(amount: 100).id
    get operation_path(test_operation_id)
    assert_response :success
  end

  test 'should get new' do
    get new_operation_path
    assert_response :success
  end

  test 'should get create' do
    Category.create(name: 'Test name')
    test_category_id = Category.find_by(name: 'Test name').id
    post operations_path, params: { operation: { category_id: test_category_id, direction: 'income', date: '2020-01-01',
                                                 amount: 100, currency: 'RUB' } }
    assert_response :found
  end

  test 'should get edit' do
    Category.create(name: 'Test name')
    test_category_id = Category.find_by(name: 'Test name').id
    Operation.create(category_id: test_category_id, direction: 'income', date: '2020-01-01', amount: 100,
                     currency: 'RUB')
    test_operation_id = Operation.find_by(amount: 100).id
    get edit_operation_path(test_operation_id)
    assert_response :success
  end

  test 'should get update' do
    Category.create(name: 'Test name')
    test_category_id = Category.find_by(name: 'Test name').id
    Operation.create(category_id: test_category_id, direction: 'income', date: '2020-01-01', amount: 100,
                     currency: 'RUB')
    test_operation_id = Operation.find_by(amount: 100).id
    patch operation_path(test_operation_id), params: { operation: { category_id: test_category_id, direction: 'income',
                                                                    date: '2020-01-01', amount: 200, currency: 'USD' } }
    assert_response :found
  end

  test 'should get destroy' do
    Category.create(name: 'Test name')
    test_category_id = Category.find_by(name: 'Test name').id
    Operation.create(category_id: test_category_id, direction: 'income', date: '2020-01-01', amount: 100,
                     currency: 'RUB')
    test_operation_id = Operation.find_by(amount: 100).id
    delete operation_path(test_operation_id)
    assert_response :see_other
  end
end
