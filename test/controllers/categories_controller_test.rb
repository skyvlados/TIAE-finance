# frozen_string_literal: true

require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get categories_path, headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :success
  end

  test 'should get show' do
    get category_path(categories(:food).id),
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :success
  end

  test 'shouldt get show category other users' do
    get category_path(categories(:food).id),
        headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'shouldnt show, bad id' do
    assert_raises(ActiveRecord::RecordNotFound) do
      get category_path(999),
          headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    end
  end

  test 'should get new' do
    get new_category_path, headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :success
  end

  test 'should get create' do
    post categories_path,
         params: { category: { name: 'test' } },
         headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :found
  end

  test 'shouldnt get create, empty params' do
    assert_raises(ActionController::ParameterMissing) do
      post categories_path,
           params: {},
           headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    end
  end

  test 'should get edit' do
    get edit_category_path(categories(:salary).id),
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :success
  end

  test 'shouldnt get edit category other users' do
    get edit_category_path(categories(:salary).id),
        headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'should get update' do
    patch category_path(categories(:goods).id),
          params: { category: { name: 'relax2' } },
          headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :found
  end

  test 'shouldnt get update category other users' do
    patch category_path(categories(:goods).id),
          params: { category: { name: 'relax2' } },
          headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'should get destroy' do
    delete category_path(categories(:relax).id),
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :see_other
  end

  test 'shouldnt get destroy category other users' do
    delete category_path(categories(:relax).id),
           headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :found
    assert_redirected_to(root_path)
  end
end
