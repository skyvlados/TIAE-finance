# frozen_string_literal: true

require 'test_helper'

class OperationsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get operations_path, headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :success
  end

  test 'should get show' do
    get operation_path(operations(:salary).id),
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :success
  end

  test 'shouldt get show operation other users' do
    get operation_path(operations(:salary).id),
        headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'shouldnt show, bad id' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get operation_path(999), headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    end
  end

  test 'should get new' do
    get new_operation_path, headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :success
  end

  test 'should get create without comment' do
    post operations_path,
         params: { operation: { category_id: categories(:salary).id,
                                direction: 'income',
                                date: '2020-01-01',
                                amount: 100,
                                currency: 'RUB' } },
         headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :found
  end

  test 'should get create with comment' do
    post operations_path,
         params: { operation: { category_id: categories(:salary).id,
                                direction: 'income',
                                date: '2020-01-01',
                                amount: 100,
                                currency: 'RUB',
                                comment: SecureRandom.alphanumeric(100) } },
         headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :found
  end

  test 'shouldnt get create, empty params' do
    assert_raises(ActionController::ParameterMissing) do
      post operations_path,
           params: {},
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    end
  end

  test 'shouldnt get create, bad params' do
    assert_raises(ArgumentError) do
      post operations_path,
           params: { operation: { category_id: categories(:salary).id,
                                  direction: 'bad',
                                  date: 'not_date',
                                  amount: 'must be number',
                                  currency: 'CURRENCY' } },
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    end
  end

  test 'shouldnt get create, category other users' do
    post operations_path,
         params: { operation: { category_id: categories(:others).id,
                                direction: 'income',
                                date: '2020-01-01',
                                amount: '100',
                                currency: 'USD' } },
         headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :forbidden
  end

  test 'shouldnt get create, comment is too long, maximim 100 symbols' do
    post operations_path,
         params: { operation: { category_id: categories(:salary).id,
                                direction: 'income',
                                date: '2020-01-01',
                                amount: 100,
                                currency: 'RUB',
                                comment: SecureRandom.alphanumeric(101) } },
         headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :unprocessable_entity
  end

  test 'should get edit' do
    get edit_operation_path(operations(:goods).id),
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :success
  end

  test 'shouldnt get edit operation other users' do
    get edit_operation_path(operations(:goods).id),
        headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'shouldnt get update, category other users' do
    post operations_path,
         params: { operation: { category_id: categories(:others).id,
                                direction: 'income',
                                date: '2020-01-01',
                                amount: '100',
                                currency: 'USD' } },
         headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :forbidden
  end

  test 'should get update' do
    patch operation_path(operations(:goods).id),
          params: { operation: { category_id: categories(:goods).id,
                                 direction: 'income',
                                 date: '2020-01-01',
                                 amount: 200,
                                 currency: 'USD',
                                 user_id: users(:admin).id } },
          headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :found
  end

  test 'should get update operation other users' do
    patch operation_path(operations(:goods).id),
          params: { operation: { category_id: categories(:goods).id,
                                 direction: 'income',
                                 date: '2020-01-01',
                                 amount: 200,
                                 currency: 'USD',
                                 user_id: users(:admin).id } },
          headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :found
  end

  test 'should get destroy' do
    delete operation_path(operations(:relax).id),
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :see_other
  end

  test 'shouldnt get destroy operation other users' do
    delete operation_path(operations(:relax).id),
           headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :found
  end

  test 'shouldnt mass delete without choose' do
    delete operations_mass_delete_path,
           params: {},
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :see_other
    assert_redirected_to(operations_path)
  end

  test 'should mass delete' do
    delete operations_mass_delete_path,
           params: { cleaner: { operations_ids: [operations(:others).id.to_s,
                                                 operations(:food).id.to_s] } },
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :found
    assert_redirected_to(operations_path)
  end

  test 'shouldnt mass delete operation other users' do
    delete operations_mass_delete_path,
           params: { cleaner: { operations_ids: [operations(:others).id.to_s,
                                                 operations(:food).id.to_s] } },
           headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :found
    assert_redirected_to(operations_path)
  end
end
