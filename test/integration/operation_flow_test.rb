# frozen_string_literal: true

require 'test_helper'

class OperationFlowTest < ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password')
    post login_path, params: { session: { email: user.email, password: password } }
  end

  test 'can see the operations list' do
    log_in_as(users(:test3))
    get '/operations'

    assert_response :success
  end

  test 'can create an operation' do
    log_in_as(users(:test3))

    post '/operations',
         params: { operation: { category_id: categories(:transport).id, direction: 'income', date: '2020-01-01',
                                amount: 100, currency: 'RUB' } }
    assert_response :redirect
    follow_redirect!
    assert_response :success

    operation = Operation.find_by(amount: 100)

    assert_select 'span', "Operation '#{operation.id}' successfully saved!"
  end

  test 'can edit an caregory' do
    category = Category.create(name: 'test')
    category2 = Category.create(name: 'test2')
    operation = Operation.create(category: category, direction: 'income', date: '2020-01-01', amount: 200,
                                 currency: 'RUB', user: users(:test3))

    log_in_as(users(:test3))
    put "/operations/#{operation.id}",
        params: { operation: { category: category2, direction: 'expenditure', date: '2022-02-02', amount: 300,
                               currency: 'USD' } }

    follow_redirect!
    assert_response :success
    assert_select 'span', 'Operation successfully updated!'
  end

  test 'can delete an operation' do
    log_in_as(users(:test3))
    operation = operations(:food)

    delete "/operations/#{operation.id}"

    assert_response :see_other
    follow_redirect!
    assert_select 'span', "Operation '#{operation.id}' successfully deleted!"
  end
end
