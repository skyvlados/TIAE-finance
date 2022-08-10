# frozen_string_literal: true

require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  test 'can see the users list' do
    get '/users'

    assert_response :success
  end

  test 'can create an user' do
    post '/users',
         params: { user: { name: 'test user', email: 'test3@example.com', password_digest: '12345678' } }

    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'span', 'Welcome to the TIAE finance App!'
  end

  test 'can edit an user' do
    user = users(:test1)

    put "/users/#{user.id}",
        params: { user: { name: 'test user', email: 'user1@example.com', password_digest: '1234' } }

    follow_redirect!
    assert_response :success
    assert_select 'span', "User 'user1' successfully updated to 'test user'!"
  end

  test 'can delete an user' do
    user = users(:test1)

    delete "/users/#{user.id}"

    assert_response :see_other
    follow_redirect!
    assert_select 'span', "User 'user1' successfully deleted!"
  end
end
