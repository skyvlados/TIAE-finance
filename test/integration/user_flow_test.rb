# frozen_string_literal: true

require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  test 'can see an users list' do
    get users_path, headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :success
  end

  test 'cant see an users list user isnt admin' do
    get users_path, headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'cant edit an users list user isnt admin' do
    put user_path(users(:user)),
        params: { user: { name: 'test user', telegram_id: 99 } },
        headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'can delete the user' do
    delete user_path(users(:user)),
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :see_other
    assert_equal flash[:notice], "User 'user' successfully deleted!"
    assert_redirected_to(users_path)
  end

  test 'cant delete an users list user isnt admin' do
    delete user_path(users(:user)),
           headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :found
    assert_redirected_to(root_path)
  end
end
