# frozen_string_literal: true

require 'test_helper'
class UserQueryTest < ActiveSupport::TestCase
  test 'by name' do
    assert_equal UserQuery.new(name: 'ser2').call.to_a, [users(:test2)]
  end

  test 'by email' do
    assert_equal UserQuery.new(email: '1@ex').call.to_a, [users(:test1)]
  end

  test 'by name and email' do
    assert_equal UserQuery.new(name: 'user', email: '1@ex').call.to_a, [users(:test1)]
  end

end
