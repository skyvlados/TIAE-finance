# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get users_path
    assert_response :success
  end

  test 'should get show' do
    test_id = users(:test1).id
    get user_path(test_id)
    assert_response :success
  end

  test 'shouldnt show, bad id' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get user_path('999')
    end
  end

  test 'should get new' do
    get new_user_path
    assert_response :success
  end

  test 'should get create' do
    post users_path, params: { user: { name: 'user test', email: 'user_test@example.com', password_digest: '1234' } }
    assert_response :found
  end

  test 'shouldnt get create, empty params' do
    assert_raises(ActionController::ParameterMissing) do
      post users_path, params: {}
    end
  end

  test 'should get edit' do
    test_id = users(:test1).id
    get edit_user_path(test_id)
    assert_response :success
  end

  test 'should get update' do
    test_id = users(:test1).id
    patch user_path(test_id),
          params: { user: { name: 'user test2', email: 'user_tes2t@example.com', password_digest: '12345' } }
    assert_response :found
  end

  test 'should get destroy' do
    test_id = users(:test1).id
    delete user_path(test_id)
    assert_response :see_other
  end
end
