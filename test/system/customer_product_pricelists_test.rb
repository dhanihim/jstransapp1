require "application_system_test_case"

class CustomerProductPricelistsTest < ApplicationSystemTestCase
  setup do
    @customer_product_pricelist = customer_product_pricelists(:one)
  end

  test "visiting the index" do
    visit customer_product_pricelists_url
    assert_selector "h1", text: "Customer Product Pricelists"
  end

  test "creating a Customer product pricelist" do
    visit customer_product_pricelists_url
    click_on "New Customer Product Pricelist"

    fill_in "Active", with: @customer_product_pricelist.active
    fill_in "Description", with: @customer_product_pricelist.description
    fill_in "Per20fr", with: @customer_product_pricelist.per20fr
    fill_in "Per20ft", with: @customer_product_pricelist.per20ft
    fill_in "Per20od", with: @customer_product_pricelist.per20od
    fill_in "Per21ft", with: @customer_product_pricelist.per21ft
    fill_in "Per40fr", with: @customer_product_pricelist.per40fr
    fill_in "Per40ft", with: @customer_product_pricelist.per40ft
    fill_in "Ppncategory", with: @customer_product_pricelist.ppncategory
    click_on "Create Customer product pricelist"

    assert_text "Customer product pricelist was successfully created"
    click_on "Back"
  end

  test "updating a Customer product pricelist" do
    visit customer_product_pricelists_url
    click_on "Edit", match: :first

    fill_in "Active", with: @customer_product_pricelist.active
    fill_in "Description", with: @customer_product_pricelist.description
    fill_in "Per20fr", with: @customer_product_pricelist.per20fr
    fill_in "Per20ft", with: @customer_product_pricelist.per20ft
    fill_in "Per20od", with: @customer_product_pricelist.per20od
    fill_in "Per21ft", with: @customer_product_pricelist.per21ft
    fill_in "Per40fr", with: @customer_product_pricelist.per40fr
    fill_in "Per40ft", with: @customer_product_pricelist.per40ft
    fill_in "Ppncategory", with: @customer_product_pricelist.ppncategory
    click_on "Update Customer product pricelist"

    assert_text "Customer product pricelist was successfully updated"
    click_on "Back"
  end

  test "destroying a Customer product pricelist" do
    visit customer_product_pricelists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Customer product pricelist was successfully destroyed"
  end
end
