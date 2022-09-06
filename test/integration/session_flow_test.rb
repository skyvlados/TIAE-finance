# frozen_string_literal: true

require 'test_helper'

class SessionFlowTest < ActionDispatch::IntegrationTest
  test 'can see autorization page' do
    get login_path
    assert_response :success
  end

  test 'can log in user' do
    post login_path, params: { session: { email: users(:confirm_user).email, password: 'password' } }
    assert_redirected_to(root_path)
    assert_response :found
  end

  test 'cant log in user, user isnt confirm' do
    post login_path, params: { session: { email: users(:not_confirm_user).email, password: 'password' } }
    assert_equal flash[:error], 'Please activate your account.
           For it click "Send confirm email" and following the instructions
           in the account confirmation email you received to proceed.'
    assert_response :unprocessable_entity
  end

  test 'cant log in user, invalid email/password combination' do
    post login_path, params: { session: { email: users(:not_confirm_user).email, password: '1234' } }
    assert_equal flash[:danger], 'Invalid email/password combination'
    assert_response :unprocessable_entity
  end

  #   test 'can send confirm email' do
  #     p users(:not_confirm_user).email
  #     post send_confirm_email_path, params: { session: { email: users(:not_confirm_user).email } }
  #     assert_equal flash[:notice], 'Email sucess sent!'
  #     assert_response :unprocessable_entity
  #   end
end
