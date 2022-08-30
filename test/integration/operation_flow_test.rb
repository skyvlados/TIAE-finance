# frozen_string_literal: true

require 'test_helper'

class OperationFlowTest < ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password')
    post login_path, params: { session: { email: user.email, password: password } }
  end

  test 'can see an operations list' do
    log_in_as(users(:admin))
    get operations_path
    assert_response :success
  end

  test 'cant see an operations list' do
    get operations_path
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'can show an operation' do
    log_in_as(users(:admin))
    get "/operations/#{operations(:relax).id}"
    assert_response :success
  end

  test 'cant show an other users operation' do
    log_in_as(users(:admin))
    get operation_path(operations(:others))
    assert flash[:notice], 'This operation is dinied for you!'
    assert_redirected_to(root_path)
  end

  test 'can create an operation' do
    log_in_as(users(:admin))
    post operations_path, params: { operation: { category_id: categories(:transport).id, direction: 'income',
                                                 date: '2020-01-01', amount: 100, currency: 'RUB' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    operation = Operation.find_by(amount: 100)
    assert_select 'span', "Operation '#{operation.id}' successfully saved!"
  end

  test 'cant create an operation' do
    post operations_path, params: { operation: { category_id: categories(:transport).id, direction: 'income',
                                                 date: '2020-01-01', amount: 100, currency: 'RUB' } }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'can edit an operation' do
    log_in_as(users(:admin))
    put operation_path(operations(:relax)), params: { operation: { category: categories(:food),
                                                                   direction: 'expenditure', date: '2022-02-02',
                                                                   amount: 300, currency: 'USD' } }
    follow_redirect!
    assert_response :success
    assert_select 'span', 'Operation successfully updated!'
  end

  test 'cant edit an operation' do
    put operation_path(operations(:relax)), params: { operation: { category: categories(:food),
                                                                   direction: 'expenditure', date: '2022-02-02',
                                                                   amount: 300, currency: 'USD' } }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'cant edit an other users operation' do
    log_in_as(users(:admin))
    put operation_path(operations(:others)), params: { operation: { category: categories(:food),
                                                                    direction: 'expenditure', date: '2022-02-02',
                                                                    amount: 300, currency: 'USD' } }
    assert flash[:notice], 'This operation is dinied for you!'
    assert_redirected_to(root_path)
  end

  test 'can delete an operation' do
    log_in_as(users(:admin))
    delete operation_path(operations(:food))
    assert_response :see_other
    follow_redirect!
    assert_select 'span', "Operation '#{operations(:food).id}' successfully deleted!"
  end

  test 'cant delete an operation' do
    delete operation_path(operations(:food))
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'cant delete an other users operation' do
    log_in_as(users(:admin))
    delete operation_path(operations(:others))
    assert flash[:notice], 'This operation is dinied for you!'
    assert_redirected_to(root_path)
  end
end
