# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password')
    post login_path, params: { session: { email: user.email, password: password } }
  end

  test 'should get index' do
    log_in_as(users(:admin))
    get users_path
    assert_response :success
  end

  test 'shouldnt get index user isnt admin' do
    log_in_as(users(:confirm_user))
    get users_path
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'should get show' do
    log_in_as(users(:admin))
    test_id = users(:not_confirm_user).id
    get user_path(test_id)
    assert_response :success
  end

  test 'shouldnt get show user isnt admin' do
    log_in_as(users(:confirm_user))
    test_id = users(:not_confirm_user).id
    get user_path(test_id)
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'shouldnt show, bad id' do
    log_in_as(users(:admin))
    assert_raises(ActiveRecord::RecordNotFound) do
      get user_path('999')
    end
  end

  test 'should get new' do
    get new_user_path
    assert_response :success
  end

  test 'should get create' do
    post users_path, params: { user: { name: 'user test', email: 'user_test@example.com', password: '1234' } }
    assert_response :found
  end

  test 'shouldnt get create, empty params' do
    assert_raises(ActionController::ParameterMissing) do
      post users_path, params: {}
    end
  end

  test 'should get edit' do
    log_in_as(users(:admin))
    test_id = users(:not_confirm_user).id
    get edit_user_path(test_id)
    assert_response :success
  end

  test 'shouldnt get edit user isnt admin' do
    log_in_as(users(:confirm_user))
    test_id = users(:not_confirm_user).id
    get edit_user_path(test_id)
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'should get update' do
    test_id = users(:not_confirm_user).id
    patch user_path(test_id),
          params: { user: { name: 'user test2', email: 'user_test2@example.com', password: '12345' } }
    assert_response :found
  end

  test 'shouldnt get update user isnt admin' do
    log_in_as(users(:confirm_user))
    test_id = users(:not_confirm_user).id
    patch user_path(test_id),
          params: { user: { name: 'user test2', email: 'user_test2@example.com', password: '12345' } }
    assert_equal flash[:notice], 'You aren\'t an admin!'
    assert_redirected_to(root_path)
  end

  test 'should get destroy' do
    log_in_as(users(:admin))
    test_id = users(:not_confirm_user).id
    delete user_path(test_id)
    assert_response :see_other
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
