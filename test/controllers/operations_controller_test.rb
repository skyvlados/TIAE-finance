# frozen_string_literal: true

require 'test_helper'

class OperationsControllerTest < ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password')
    post login_path, params: { session: { email: user.email, password: password } }
  end

  test 'should get index' do
    log_in_as(users(:test3))
    get operations_path
    assert_response :success
  end

  test 'should get show' do
    log_in_as(users(:test3))
    test_operation_id = operations(:salary).id
    get operation_path(test_operation_id)
    assert_response :success
  end

  test 'shouldnt show, bad id' do
    log_in_as(users(:test3))
    assert_raises(ActiveRecord::RecordNotFound) do
      get operation_path(999)
    end
  end

  test 'should get new' do
    log_in_as(users(:test3))
    get new_operation_path
    assert_response :success
  end

  test 'should get create' do
    log_in_as(users(:test3))
    test_category_id = categories(:salary).id
    post operations_path, params: { operation: { category_id: test_category_id, direction: 'income', date: '2020-01-01',
                                                 amount: 100, currency: 'RUB' } }
    assert_response :found
  end

  test 'shouldnt get create, empty params' do
    assert_raises(ActionController::ParameterMissing) do
      post operations_path, params: {}
    end
  end

  test 'shouldnt get create, bad params' do
    log_in_as(users(:test3))
    assert_raises(ArgumentError) do
      post operations_path, params: { operation: { category_id: 'test', direction: 'bad', date: 'not_date',
                                                   amount: 'must be number', currency: 'CURRENCY' } }
    end
  end

  test 'should get edit' do
    log_in_as(users(:test3))
    test_operation_id = operations(:goods).id
    get edit_operation_path(test_operation_id)
    assert_response :success
  end

  test 'should get update' do
    log_in_as(users(:test3))
    test_category_id = categories(:goods).id
    test_operation_id = operations(:goods).id
    patch operation_path(test_operation_id), params: { operation: { category_id: test_category_id, direction: 'income',
                                                                    date: '2020-01-01', amount: 200, currency: 'USD',
                                                                    user_id: users(:test3).id } }
    assert_response :found
  end

  test 'should get destroy' do
    test_operation_id = operations(:relax).id
    delete operation_path(test_operation_id)
    assert_response :see_other
  end
end
