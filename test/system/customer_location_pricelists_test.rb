require "application_system_test_case"

class CustomerLocationPricelistsTest < ApplicationSystemTestCase
  setup do
    @customer_location_pricelist = customer_location_pricelists(:one)
  end

  test "visiting the index" do
    visit customer_location_pricelists_url
    assert_selector "h1", text: "Customer Location Pricelists"
  end

  test "creating a Customer location pricelist" do
    visit customer_location_pricelists_url
    click_on "New Customer Location Pricelist"

    fill_in "Active", with: @customer_location_pricelist.active
    fill_in "Customer location from", with: @customer_location_pricelist.customer_location_from
    fill_in "Customer location to", with: @customer_location_pricelist.customer_location_to
    fill_in "Description", with: @customer_location_pricelist.description
    fill_in "Per20fr", with: @customer_location_pricelist.per20fr
    fill_in "Per20ft", with: @customer_location_pricelist.per20ft
    fill_in "Per20od", with: @customer_location_pricelist.per20od
    fill_in "Per21ft", with: @customer_location_pricelist.per21ft
    fill_in "Per40fr", with: @customer_location_pricelist.per40fr
    fill_in "Per40ft", with: @customer_location_pricelist.per40ft
    fill_in "Ppncategory", with: @customer_location_pricelist.ppncategory
    click_on "Create Customer location pricelist"

    assert_text "Customer location pricelist was successfully created"
    click_on "Back"
  end

  test "updating a Customer location pricelist" do
    visit customer_location_pricelists_url
    click_on "Edit", match: :first

    fill_in "Active", with: @customer_location_pricelist.active
    fill_in "Customer location from", with: @customer_location_pricelist.customer_location_from
    fill_in "Customer location to", with: @customer_location_pricelist.customer_location_to
    fill_in "Description", with: @customer_location_pricelist.description
    fill_in "Per20fr", with: @customer_location_pricelist.per20fr
    fill_in "Per20ft", with: @customer_location_pricelist.per20ft
    fill_in "Per20od", with: @customer_location_pricelist.per20od
    fill_in "Per21ft", with: @customer_location_pricelist.per21ft
    fill_in "Per40fr", with: @customer_location_pricelist.per40fr
    fill_in "Per40ft", with: @customer_location_pricelist.per40ft
    fill_in "Ppncategory", with: @customer_location_pricelist.ppncategory
    click_on "Update Customer location pricelist"

    assert_text "Customer location pricelist was successfully updated"
    click_on "Back"
  end

  test "destroying a Customer location pricelist" do
    visit customer_location_pricelists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Customer location pricelist was successfully destroyed"
  end
end
