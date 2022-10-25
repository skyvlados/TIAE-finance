# frozen_string_literal: true

require 'test_helper'

class OperationsControllerTest < ActionDispatch::IntegrationTest
  include Loginable

  test 'should get index' do
    login_as(users(:admin))
    get operations_path
    assert_response :success
  end

  test 'shouldnt get index' do
    get operations_path
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'should get show' do
    login_as(users(:admin))
    get operation_path(operations(:salary).id)
    assert_response :success
  end

  test 'shouldnt get show' do
    get operation_path(operations(:salary).id)
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'shouldt get show operation other users' do
    login_as(users(:confirm_user))
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'shouldnt show, bad id' do
    login_as(users(:admin))
    assert_raises(ActiveRecord::RecordNotFound) do
      get operation_path(999)
    end
  end

  test 'should get new' do
    login_as(users(:admin))
    get new_operation_path
    assert_response :success
  end

  test 'shouldnt get new' do
    get new_operation_path
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'should get create' do
    login_as(users(:admin))
    post operations_path, params: { operation: { category_id: categories(:salary).id, direction: 'income',
                                                 date: '2020-01-01', amount: 100, currency: 'RUB' } }
    assert_response :found
  end

  test 'shouldnt get create' do
    post operations_path, params: { operation: { category_id: categories(:salary).id, direction: 'income',
                                                 date: '2020-01-01', amount: 100, currency: 'RUB' } }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'shouldnt get create, empty params' do
    login_as(users(:admin))
    assert_raises(ActionController::ParameterMissing) do
      post operations_path, params: {}
    end
  end

  test 'shouldnt get create, bad params' do
    login_as(users(:admin))
    assert_raises(ArgumentError) do
      post operations_path, params: { operation: { category_id: categories(:salary).id, direction: 'bad',
                                                   date: 'not_date', amount: 'must be number', currency: 'CURRENCY' } }
    end
  end

  test 'shouldnt get create, category other users' do
    login_as(users(:admin))
    post operations_path, params: { operation: { category_id: categories(:others).id, direction: 'income',
                                                 date: '2020-01-01', amount: '100', currency: 'USD' } }
    assert_response :forbidden
  end

  test 'should get edit' do
    login_as(users(:admin))
    get edit_operation_path(operations(:goods).id)
    assert_response :success
  end

  test 'shouldnt get edit' do
    get edit_operation_path(operations(:goods).id)
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'shouldnt get update, category other users' do
    login_as(users(:admin))
    post operations_path, params: { operation: { category_id: categories(:others).id, direction: 'income',
                                                 date: '2020-01-01', amount: '100', currency: 'USD' } }
    assert_response :forbidden
  end

  test 'should get update' do
    login_as(users(:admin))
    patch operation_path(operations(:goods).id), params: { operation: { category_id: categories(:goods).id,
                                                                        direction: 'income', date: '2020-01-01',
                                                                        amount: 200, currency: 'USD',
                                                                        user_id: users(:admin).id } }
    assert_response :found
  end

  test 'shouldnt get update' do
    patch operation_path(operations(:goods).id), params: { operation: { category_id: categories(:goods).id,
                                                                        direction: 'income', date: '2020-01-01',
                                                                        amount: 200, currency: 'USD',
                                                                        user_id: users(:admin).id } }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'should get destroy' do
    login_as(users(:admin))
    delete operation_path(operations(:relax).id)
    assert_response :see_other
  end

  test 'shouldnt get destroy' do
    delete operation_path(operations(:relax).id)
    assert_response :found
    assert_redirected_to(root_path)
  end
end
