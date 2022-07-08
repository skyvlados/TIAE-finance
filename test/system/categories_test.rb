require "application_system_test_case"

class CategoriesTest < ApplicationSystemTestCase
  test "viewing the categories index" do
    visit categories_path
    assert_selector "h1", text: "Categories list"
    assert_selector "h1", text: "Categories list"
  end

  test "should create category" do
    visit categories_path
  
    click_on "Create"
  
    fill_in "Name", with: "Test category"
  
    click_on "Save"
  
    assert_text "Category 'Test category' successfully saved!"
  end
end
