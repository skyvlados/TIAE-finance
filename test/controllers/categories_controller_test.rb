# frozen_string_literal: true

require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get categories_path
    assert_response :success
  end

  test 'should get show' do
    Category.create(name: 'Test name')
    test_id = Category.find_by(name: 'Test name').id
    get category_path(test_id)
    assert_response :success
  end

  test 'should get new' do
    get new_category_path
    assert_response :success
  end

  test 'should get create' do
    post categories_path, params: { category: { name: 'test' } }
    assert_response :found
  end

  test 'should get edit' do
    Category.create(name: 'Test name')
    test_id = Category.find_by(name: 'Test name').id
    get edit_category_path(test_id)
    assert_response :success
  end

  test 'should get update' do
    Category.create(name: 'Test name')
    test_id = Category.find_by(name: 'Test name').id
    patch category_path(test_id), params: { category: { name: 'test' } }
    assert_response :found
  end

  test 'should get destroy' do
    Category.create(name: 'Test name')
    test_id = Category.find_by(name: 'Test name').id
    delete category_path(test_id)
    assert_response :see_other
  end
end
