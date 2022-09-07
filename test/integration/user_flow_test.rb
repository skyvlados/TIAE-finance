# frozen_string_literal: true

require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  include Loginable

  test 'can see an users list' do
    login_as(users(:admin))
    get users_path
    assert_response :success
  end

  test 'cant see an users list' do
    get users_path
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'cant see an users list user isnt admin' do
    login_as(users(:confirm_user))
    get users_path
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'can create the user' do
    post users_path, params: { user: { name: 'test user', email: 'test3@example.com', password: '12345678' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'span', 'You are registered. To continue you need confirm email, check your email'
  end

  test 'can edit the user' do
    login_as(users(:admin))
    put user_path(users(:not_confirm_user)),
        params: { user: { name: 'test user', email: 'user1@example.com', password: '1234' } }
    follow_redirect!
    assert_response :success
    assert_select 'span', "User 'not_confirm_user' successfully updated to 'test user'!"
  end

  test 'cant edit the users' do
    put user_path(users(:not_confirm_user)),
        params: { user: { name: 'test user', email: 'user1@example.com', password: '1234' } }
    assert_response :found
    assert_equal flash[:notice], 'First of all you must authorization!'
    assert_redirected_to(root_path)
  end

  test 'cant edit an users list user isnt admin' do
    login_as(users(:confirm_user))
    put user_path(users(:not_confirm_user)),
        params: { user: { name: 'test user', email: 'user1@example.com', password: '1234' } }
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'can delete the user' do
    login_as(users(:admin))
    delete user_path(users(:not_confirm_user))
    assert_response :see_other
    assert_equal flash[:notice], "User 'not_confirm_user' successfully deleted!"
    assert_redirected_to(users_path)
  end

  test 'cant delete the users' do
    delete user_path(users(:not_confirm_user))
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'cant delete an users list user isnt admin' do
    login_as(users(:confirm_user))
    delete user_path(users(:not_confirm_user))
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'can confirm email' do
    get confirm_email_path(12_345_678)
    assert_equal flash[:success],
                 'Welcome to the Sample App! Your email has been confirmed. Please sign in to continue.'
  end

  test 'cant confirm email' do
    get confirm_email_path(1_234_567_891_011)
    assert_equal flash[:error], 'Sorry. User does not exist'
  end
end
