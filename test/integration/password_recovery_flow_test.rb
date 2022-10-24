# frozen_string_literal: true

require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  include Loginable

  test 'can see forgot password form' do
    get forgot_password_path
    assert_response :success
  end

  test 'cant send email with forgot password link, user not found' do
    post password_recovery_path, params: { user: { email: 'not_exist_user@example.com' } }
    assert_response :found
    follow_redirect!
    assert_response :success
    assert_equal flash[:error], 'This email hasn\'t been registered yet'
  end

  test 'can send email with forgot password link' do
    post password_recovery_path, params: { user: { email: users(:recovery_password_user).email } }
    assert_response :found
    follow_redirect!
    assert_response :success
    assert_equal flash[:success],
                 "Letter with instruction send to your email adress #{users(:recovery_password_user).email}."
  end

  test 'can see new password form' do
    get set_new_password_form_path(1234)
    assert_response :success
  end

  test 'cant save new password, password form is empty' do
    post set_new_password_path, params: { user: { password: '' } }
    assert_response :found
    assert_equal flash[:error], 'Password cannot be empty!'
    assert_redirected_to(set_new_password_path)
  end

  test 'cant save new password, not exist token' do
    post set_new_password_path, params: { user: { password: '1234', token: 'not_exist_token' } }
    assert_response :found
    assert_equal flash[:error], 'Sorry. User does not exist or password has already been recovered'
    assert_redirected_to(root_path)
  end

  test 'can save new password' do
    post set_new_password_path, params: { user: { password: '1234', token: 'confirm_recovery_password_token' } }
    assert_response :found
    assert_equal flash[:success], 'Your new password success saved! Enter your new password to login.'
    assert_redirected_to(root_path)
  end
end
