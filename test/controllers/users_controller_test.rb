# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get users_path, headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :success
  end

  test 'shouldnt get index user isnt admin' do
    get users_path, headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'should get show' do
    test_id = users(:user).id
    get users_path(test_id), headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :success
  end

  test 'shouldnt get show user isnt admin' do
    test_id = users(:user).id
    get users_path(test_id), headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'shouldnt show, bad id' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get user_path(999), headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    end
  end

  test 'should get edit' do
    test_id = users(:user).id
    get users_path(test_id), headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :success
  end

  test 'shouldnt get edit user isnt admin' do
    test_id = users(:user).id
    get users_path(test_id), headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'should get update' do
    test_id = users(:user).id
    patch user_path(test_id),
          params: {
            user: { name: 'user2', telegram_id: 3 }
          },
          headers: {
            'Auth-User-Id' => '1',
            'Auth-User-First-Name' => 'admin'
          }
    assert_response :found
  end

  test 'shouldnt get update user isnt admin' do
    test_id = users(:user).id
    patch user_path(test_id),
          params: {
            user: { name: 'user2', telegram_id: 3 }
          },
          headers: {
            'Auth-User-Id' => '2',
            'Auth-User-First-Name' => 'user'
          }
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'should get destroy' do
    test_id = users(:user).id
    delete user_path(test_id), headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :see_other
  end

  test 'shouldnt get destroy user isnt admin' do
    test_id = users(:user).id
    delete user_path(test_id), headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end
end
