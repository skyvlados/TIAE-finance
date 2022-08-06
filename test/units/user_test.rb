# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should not save user without name, email and password' do
    user = User.new
    assert_not user.save
  end

  test 'should save user' do
    user = User.new(name: 'Test user', email: 'test3@example.com', password: '1234')
    assert user.save
  end

  test 'should not edit user' do
    user = users(:test1)
    assert_not user.update(name: '', email: 'test3@example.com', password: '1234')
    assert_not user.update(name: 'test user', email: '', password: '1234')
    assert_not user.update(name: 'test user', email: 'test3@example.com', password: '')
  end

  test 'should edit user' do
    user = users(:test1)
    assert user.update(name: 'test user', email: 'test3@example.com', password: '12345678')
  end

  test 'should delete user' do
    user = users(:test1)
    assert user.destroy
  end
end