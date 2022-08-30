# frozen_string_literal: true

require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password')
    post login_path, params: { session: { email: user.email, password: password } }
  end

  test 'should get index' do
    log_in_as(users(:admin))
    get categories_path
    assert_response :success
  end

  test 'shouldnt get index' do
    get categories_path
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'should get show' do
    log_in_as(users(:admin))
    get category_path(categories(:food).id)
    assert_response :success
  end

  test 'shouldnt get show' do
    get category_path(categories(:food).id)
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'shouldt get show category other users' do
    log_in_as(users(:test2))
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'shouldnt show, bad id' do
    log_in_as(users(:admin))
    assert_raises(ActiveRecord::RecordNotFound) do
      get category_path(999)
    end
  end

  test 'should get new' do
    log_in_as(users(:admin))
    get new_category_path
    assert_response :success
  end

  test 'shouldnt get new' do
    get new_category_path
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'should get create' do
    log_in_as(users(:admin))
    post categories_path, params: { category: { name: 'test' } }
    assert_response :found
  end

  test 'shouldnt get create' do
    post categories_path, params: { category: { name: 'test' } }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'shouldnt get create, empty params' do
    log_in_as(users(:admin))
    assert_raises(ActionController::ParameterMissing) do
      post categories_path, params: {}
    end
  end

  test 'should get edit' do
    log_in_as(users(:admin))
    get edit_category_path(categories(:salary).id)
    assert_response :success
  end

  test 'shouldnt get edit' do
    get edit_category_path(categories(:salary).id)
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'should get update' do
    log_in_as(users(:admin))
    patch category_path(categories(:goods).id), params: { category: { name: 'relax2' } }
    assert_response :found
  end

  test 'shouldnt get update' do
    patch category_path(categories(:goods).id), params: { category: { name: 'relax2' } }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'should get destroy' do
    log_in_as(users(:admin))
    delete category_path(categories(:relax).id)
    assert_response :see_other
  end

  test 'shouldnt get destroy' do
    delete category_path(categories(:relax).id)
    assert_response :found
    assert_redirected_to(root_path)
  end
end
