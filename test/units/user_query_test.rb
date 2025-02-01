# frozen_string_literal: true

require 'test_helper'
class UserQueryTest < ActiveSupport::TestCase
  test 'by name' do
    assert_equal UserQuery.new(name: 'in').call.to_a, [users(:admin)]
  end

  test 'by telegram_id' do
    assert_equal UserQuery.new(telegram_id: 2).call.to_a, [users(:user)]
  end

  test 'by name and telegram_id' do
    assert_equal UserQuery.new(name: 'user', telegram_id: 2).call.to_a, [users(:user)]
  end
end
