# frozen_string_literal: true

require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get categories_path
    assert_response :success
  end

  test 'should get show' do
    test_id = categories(:food).id
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
    test_id = categories(:salary).id
    get edit_category_path(test_id)
    assert_response :success
  end

  test 'should get update' do
    test_id = categories(:goods).id
    patch category_path(test_id), params: { category: { name: 'relax2' } }
    assert_response :found
  end

  test 'should get destroy' do
    test_id = categories(:relax).id
    delete category_path(test_id)
    assert_response :see_other
  end
end
