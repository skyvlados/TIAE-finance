# frozen_string_literal: true

require 'test_helper'

class OperationsHelperTest < ActiveSupport::TestCase
  include OperationsHelper

  test "correct render human currency" do
    assert human_amount(12, :usd) == "12 $"
  end

  test "correct render human currency with fallback" do
    assert human_amount(12, :ron) == "12 RON"
  end

  test "correct render human currency in lowercase" do
    assert human_amount(12, "ron") == "12 RON"
  end

  test "correct render human currency in uppercase" do
    assert human_amount(12, "RON") == "12 RON"
  end

end

class OperationTest < ActiveSupport::TestCase

    test "should not save category without name without direction" do
        category=Category.create(name: "Test")
        operation=Operation.new(category: category, date: '2020-01-01', amount: 100, currency: 1)
        assert_not operation.save
    end

    test "should not save operation without name without category_id" do
        operation=Operation.new(direction: 2, date: '2020-01-01', amount: 100, currency: 1)
        assert_not operation.save
    end

    test "should not save operation without name without date" do
        category=Category.create(name: "Test")
        operation=Operation.new(direction: 2, category: category, amount: 100, currency: 1)
        assert_not operation.save
    end

    test "should not save operation without name without amount" do
        category=Category.create(name: "Test")
        operation=Operation.new(direction: 2, category: category, date: '2020-01-01', currency: 1)
        assert_not operation.save
    end

    test "should not save operation without name without currency" do
        category=Category.create(name: "Test")
        operation=Operation.new(direction: 2, category: category, date: '2020-01-01', amount: 100)
        assert_not operation.save
    end

    test "should save operation" do
        category=Category.create(name: "Test")
        operation=Operation.new(direction: 2, category: category, date: '2020-01-01', amount: 100, currency: 1)
        assert operation.save
    end

    test "should not edit category without name without direction" do
        category=Category.create(name: "Test")
        operation=Operation.create(direction: 2, category: category, date: '2020-01-01', amount: 100, currency: 1)
        assert_not operation.update(direction: nil, category: category, date: '2020-01-02', amount: 200, currency: 2)
    end

    test "should not edit operation without name without category_id" do
        category=Category.create(name: "Test")
        operation=Operation.create(direction: 2, category: category, date: '2020-01-01', amount: 100, currency: 1)
        assert_not operation.update(direction: 1, category: nil, date: '2020-01-02', amount: 200, currency: 2)
    end

    test "should not edit operation without name without date" do
        category=Category.create(name: "Test")
        operation=Operation.create(direction: 2, category: category, date: '2020-01-01', amount: 100, currency: 1)
        assert_not operation.update(direction: 1, category: category, date: nil, amount: 200, currency: 2)
    end

    test "should not edit operation without name without amount" do
        category=Category.create(name: "Test")
        operation=Operation.create(direction: 2, category: category, date: '2020-01-01', amount: 100, currency: 1)
        assert_not operation.update(direction: 1, category: category, date: '2020-01-02', amount: nil, currency: 2)
    end

    test "should not edit operation without name without currency" do
        category=Category.create(name: "Test")
        operation=Operation.create(direction: 2, category: category, date: '2020-01-01', amount: 100, currency: 1)
        assert_not operation.update(direction: 1, category: category, date: '2020-01-02', amount: 200, currency: nil)
    end

    test "should edit operation" do
        category=Category.create(name: "Test")
        category2=Category.create(name: "Test2")
        operation=Operation.create(direction: 2, category: category, date: '2020-01-01', amount: 100, currency: 1)
        assert operation.update(direction: 1, category: category2, date: '2020-01-02', amount: 200, currency: 2)
    end

    test "should delete operation" do
        category=Category.create(name: "Test")
        operation=Operation.create(direction: 2, category: category, date: '2020-01-01', amount: 100, currency: 1)
        assert operation.destroy
    end
end
