# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password')
    post login_path, params: { session: { email: user.email, password: password } }
  end

  test 'should get index' do
    log_in_as(users(:test3))
    get users_path
    assert_response :success
  end

  test 'should get show' do
    log_in_as(users(:test3))
    test_id = users(:test1).id
    get user_path(test_id)
    assert_response :success
  end

  test 'shouldnt show, bad id' do
    log_in_as(users(:test3))
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
    log_in_as(users(:test3))
    test_id = users(:test1).id
    get edit_user_path(test_id)
    assert_response :success
  end

  test 'should get update' do
    test_id = users(:test1).id
    patch user_path(test_id),
          params: { user: { name: 'user test2', email: 'user_test2@example.com', password: '12345' } }
    assert_response :found
  end

  test 'should get destroy' do
    log_in_as(users(:test3))
    test_id = users(:test1).id
    delete user_path(test_id)
    assert_response :see_other
  end
end
