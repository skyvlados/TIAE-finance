# frozen_string_literal: true

require 'test_helper'

class OperationFlowTest < ActionDispatch::IntegrationTest
  test 'can see an operations list' do
    get operations_path, headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :success
  end

  test 'can show an operation' do
    get "/operations/#{operations(:relax).id}",
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :success
  end

  test 'cant show an other users operation' do
    get operation_path(operations(:others)),
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert flash[:info], 'This operation is dinied for you!'
    assert_redirected_to(root_path)
  end

  test 'can create an operation' do
    post operations_path,
         params: { operation: { category_id: categories(:transport).id, direction: 'income',
                                date: '2020-01-01', amount: 100, currency: 'RUB' } },
         headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    operation = Operation.find_by(amount: 100)
    assert_select 'span', "Operation '#{operation.id}' successfully saved!"
  end

  test 'cant create an operation, category another user' do
    post operations_path,
         params: { operation: { category_id: categories(:others).id, direction: 'income',
                                date: '2020-01-01', amount: 100, currency: 'RUB' } },
         headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :forbidden
  end

  test 'can edit an operation' do
    put operation_path(operations(:relax)),
        params: { operation: { category_id: categories(:food).id,
                               direction: 'expenditure', date: '2022-02-02',
                               amount: 300, currency: 'USD' } },
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    follow_redirect!
    assert_response :success
    assert_select 'span', 'Operation successfully updated!'
  end

  test 'cant edit an operation, category another user' do
    put operation_path(operations(:relax)),
        params: { operation: { category_id: categories(:others).id,
                               direction: 'income', date: '2020-01-01',
                               amount: 100, currency: 'RUB' } },
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :forbidden
  end

  test 'cant edit an other users operation' do
    put operation_path(operations(:others)),
        params: { operation: { category: categories(:food),
                               direction: 'expenditure', date: '2022-02-02',
                               amount: 300, currency: 'USD' } },
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert flash[:info], 'This operation is dinied for you!'
    assert_redirected_to(root_path)
  end

  test 'can delete an operation' do
    delete operation_path(operations(:food)),
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :see_other
    follow_redirect!
    assert_select 'span', "Operation '#{operations(:food).id}' successfully deleted!"
  end

  test 'cant delete an other users operation' do
    delete operation_path(operations(:others)),
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert flash[:info], 'This operation is dinied for you!'
    assert_redirected_to(root_path)
  end

  test 'cant mass delete operation without params' do
    delete operations_mass_delete_path,
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert flash[:info], 'First of all choose at least one operation!'
    assert_redirected_to(operations_path)
  end

  test 'can mass delete operations' do
    delete operations_mass_delete_path,
           params: { cleaner: { operations_ids: [operations(:others).id.to_s,
                                                 operations(:food).id.to_s] } },
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert flash[:notice], 'Operations successfully deleted!'
    assert_redirected_to(operations_path)
  end
end
