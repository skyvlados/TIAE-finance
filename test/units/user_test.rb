# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should not save user without name, telegram_id' do
    user = User.new
    assert_not user.save
  end

  test 'should save user' do
    user = User.new(name: 'Test user', telegram_id: 3)
    assert user.save
  end

  test 'should not edit user' do
    user = users(:user)
    assert_not user.update(name: '', telegram_id: 2)
  end

  test 'should edit user' do
    user = users(:user)
    assert user.update(name: 'test user', telegram_id: 2)
  end
end
