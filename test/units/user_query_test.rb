# frozen_string_literal: true

require 'test_helper'
class UserQueryTest < ActiveSupport::TestCase
  test 'by name' do
    assert_equal UserQuery.new(name: 'in').call.to_a, [users(:admin)]
  end

  test 'by email' do
    assert_equal UserQuery.new(email: '1@EX').call.to_a, [users(:not_confirm_user)]
  end

  test 'by name and email' do
    assert_equal UserQuery.new(name: 'user', email: '1@Ex').call.to_a, [users(:not_confirm_user)]
  end
end
