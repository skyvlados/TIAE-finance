# frozen_string_literal: true

require 'test_helper'

class CategoryFlowTest < ActionDispatch::IntegrationTest
  test 'can see an welcome page' do
    get '/', headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :success
  end

  test 'can see an categories list' do
    get categories_path, headers: { 'Auth-User-Id' => '2', 'Auth-User-First-Name' => 'user' }
    assert_response :success
  end

  test 'can show an category' do
    get category_path(categories(:food)),
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :success
  end

  test 'cant show an other users category' do
    get category_path(categories(:others)),
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert flash[:info], 'This category is dinied for you!'
    assert_redirected_to(root_path)
  end

  test 'can create an caregory' do
    post categories_path, params: { category: { name: 'test' } },
                          headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'span', "Category 'test' successfully saved!"
  end

  test 'can edit an caregory' do
    put category_path(categories(:goods)),
        params: { category: { name: 'test2' } },
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    follow_redirect!
    assert_response :success
    assert_select 'span', "Category 'goods' successfully updated to 'test2'!"
  end

  test 'cant edit an other users caregory' do
    put category_path(categories(:others)),
        params: { category: { name: 'test2' } },
        headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :found
    assert flash[:info], 'This category is dinied for you!'
    assert_redirected_to(root_path)
  end

  test 'can delete an caregory' do
    delete category_path(categories(:transport)),
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :see_other
    follow_redirect!
    assert_select 'span', "Category 'transport' successfully deleted!"
  end

  test 'cant delete an other users caregory' do
    delete category_path(categories(:others)),
           headers: { 'Auth-User-Id' => '1', 'Auth-User-First-Name' => 'admin' }
    assert_response :found
    assert flash[:info], 'This category is dinied for you!'
    assert_redirected_to(root_path)
  end
end
