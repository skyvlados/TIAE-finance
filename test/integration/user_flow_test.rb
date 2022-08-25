# frozen_string_literal: true

require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password')
    post login_path, params: { session: { email: user.email, password: password } }
  end

  test 'can see an users list' do
    log_in_as(users(:test3))
    get users_path
    assert_response :success
  end

  test 'cant see an users list' do
    get users_path
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'can create the user' do
    log_in_as(users(:test3))
    post users_path, params: { user: { name: 'test user', email: 'test3@example.com', password: '12345678' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'span', 'Welcome to the TIAE finance App!'
  end

  test 'cant create the users' do
    post users_path, params: { user: { name: 'test user', email: 'test3@example.com', password: '12345678' } }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'can edit the user' do
    log_in_as(users(:test3))
    put user_path(users(:test1)), params: { user: { name: 'test user', email: 'user1@example.com', password: '1234' } }
    follow_redirect!
    assert_response :success
    assert_select 'span', "User 'user1' successfully updated to 'test user'!"
  end

  test 'cant edit the users' do
    put user_path(users(:test1)), params: { user: { name: 'test user', email: 'user1@example.com', password: '1234' } }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'can delete the user' do
    log_in_as(users(:test3))
    delete user_path(users(:test1))
    assert_response :see_other
    follow_redirect!
    assert_select 'span', "User 'user1' successfully deleted!"
  end

  test 'cant delete the users' do
    delete user_path(users(:test1))
    assert_response :found
    assert_redirected_to(root_path)
  end
end
