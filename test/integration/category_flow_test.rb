# frozen_string_literal: true

require 'test_helper'

class CategoryFlowTest < ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password')
    post login_path, params: { session: { email: user.email, password: password } }
  end

  test 'can see an welcome page' do
    get '/'
    assert_response :success
  end

  test 'can see an categories list' do
    log_in_as(users(:test3))
    get categories_path
    assert_response :success
  end

  test 'cant see an categories list' do
    get categories_path
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'can show an category' do
    log_in_as(users(:test3))
    get category_path(categories(:food))
    assert_response :success
  end

  test 'cant show an other users category' do
    log_in_as(users(:test3))
    get category_path(categories(:others))
    assert flash[:notice], 'This category is dinied for you!'
    assert_redirected_to(root_path)
  end

  test 'can create an caregory' do
    log_in_as(users(:test3))
    post categories_path, params: { category: { name: 'test' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'span', "Category 'test' successfully saved!"
  end

  test 'cant create an caregory' do
    post categories_path, params: { category: { name: 'test' } }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'can edit an caregory' do
    log_in_as(users(:test3))
    put category_path(categories(:goods)), params: { category: { name: 'test2' } }
    follow_redirect!
    assert_response :success
    assert_select 'span', "Category 'goods' successfully updated to 'test2'!"
  end

  test 'cant edit an caregory' do
    put category_path(categories(:goods)), params: { category: { name: 'test2' } }
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'cant edit an other users caregory' do
    log_in_as(users(:test3))
    put category_path(categories(:others)), params: { category: { name: 'test2' } }
    assert_response :found
    assert flash[:notice], 'This category is dinied for you!'
    assert_redirected_to(root_path)
  end

  test 'can delete an caregory' do
    log_in_as(users(:test3))
    delete category_path(categories(:transport))
    assert_response :see_other
    follow_redirect!
    assert_select 'span', "Category 'transport' successfully deleted!"
  end

  test 'cant delete an caregory' do
    delete category_path(categories(:transport))
    assert_response :found
    assert_redirected_to(root_path)
  end

  test 'cant delete an other users caregory' do
    log_in_as(users(:test3))
    delete category_path(categories(:others))
    assert_response :found
    assert flash[:notice], 'This category is dinied for you!'
    assert_redirected_to(root_path)
  end
end
