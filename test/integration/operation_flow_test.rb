require "test_helper"

class OperationFlowTest < ActionDispatch::IntegrationTest

  test "can see the operations list" do
    get "/operations"
    assert_response :success
  end

  test "can create an operation" do
    category = Category.create(name: "test")
    operation = post "/operations",
      params: { operation: {category: category, direction: "income", date: '2020-01-01', amount: 100, currency: "RUB"} }
    p Operation.all # не получается создать операцию
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "span", "Operation '#{operation.id}' successfully saved!"
  end

  test "can edit an caregory" do
    category=Category.create(name: "test")
    category2=Category.create(name: "test2")
    operation=Operation.create(category: category, direction: "income", date: '2020-01-01', amount: 200, currency: "RUB")
    put "/operations/#{operation.id}",
      params: { operation: {category: category2, direction: "expenditure", date: '2022-02-02', amount: 300, currency: "USD"} }
    follow_redirect!
    assert_response :success
    assert_select "span", "Operation successfully updated!"
  end

  test "can delete an caregory" do
    category=Category.create(name: "test")
    operation=Operation.create(category: category, direction: "income", date: '2020-01-01', amount: 200, currency: "RUB")
    delete "/operations/#{operation.id}"
    assert_response :see_other
    follow_redirect!
    assert_select "span", "Category '#{operation.id}' successfully deleted!" #почему-то в этом месте теста ошибка((
  end
end

