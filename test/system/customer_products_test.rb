require "application_system_test_case"

class CustomerProductsTest < ApplicationSystemTestCase
  setup do
    @customer_product = customer_products(:one)
  end

  test "visiting the index" do
    visit customer_products_url
    assert_selector "h1", text: "Customer Products"
  end

  test "creating a Customer product" do
    visit customer_products_url
    click_on "New Customer Product"

    fill_in "Active", with: @customer_product.active
    fill_in "Description", with: @customer_product.description
    fill_in "Name", with: @customer_product.name
    fill_in "Uom", with: @customer_product.uom
    click_on "Create Customer product"

    assert_text "Customer product was successfully created"
    click_on "Back"
  end

  test "updating a Customer product" do
    visit customer_products_url
    click_on "Edit", match: :first

    fill_in "Active", with: @customer_product.active
    fill_in "Description", with: @customer_product.description
    fill_in "Name", with: @customer_product.name
    fill_in "Uom", with: @customer_product.uom
    click_on "Update Customer product"

    assert_text "Customer product was successfully updated"
    click_on "Back"
  end

  test "destroying a Customer product" do
    visit customer_products_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Customer product was successfully destroyed"
  end
end
