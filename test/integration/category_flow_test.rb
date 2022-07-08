require 'test_helper'

class CategoryFlowTest < ActionDispatch::IntegrationTest
  test 'can see the welcome page' do
    get '/'
    assert_response :success
  end

  test 'can see the categories list' do
    get '/categories'
    assert_response :success
  end

  test 'can create an caregory' do
    post '/categories',
         params: { category: { name: 'test' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'span', "Category 'test' successfully saved!"
  end

  test 'can edit an caregory' do
    category = Category.create(name: 'test')
    put "/categories/#{category.id}",
        params: { category: { name: 'test2' } }
    follow_redirect!
    assert_response :success
    assert_select 'span', "Category 'test' successfully updated to 'test2'!"
  end

  test 'can delete an caregory' do
    category = Category.create(name: 'test')
    delete "/categories/#{category.id}"
    assert_response :see_other
    follow_redirect!
    assert_select 'span', "Category 'test' successfully deleted!"
  end
end
