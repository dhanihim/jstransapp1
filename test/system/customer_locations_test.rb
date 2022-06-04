require "application_system_test_case"

class CustomerLocationsTest < ApplicationSystemTestCase
  setup do
    @customer_location = customer_locations(:one)
  end

  test "visiting the index" do
    visit customer_locations_url
    assert_selector "h1", text: "Customer Locations"
  end

  test "creating a Customer location" do
    visit customer_locations_url
    click_on "New Customer Location"

    fill_in "Active", with: @customer_location.active
    fill_in "Address", with: @customer_location.address
    fill_in "Description", with: @customer_location.description
    click_on "Create Customer location"

    assert_text "Customer location was successfully created"
    click_on "Back"
  end

  test "updating a Customer location" do
    visit customer_locations_url
    click_on "Edit", match: :first

    fill_in "Active", with: @customer_location.active
    fill_in "Address", with: @customer_location.address
    fill_in "Description", with: @customer_location.description
    click_on "Update Customer location"

    assert_text "Customer location was successfully updated"
    click_on "Back"
  end

  test "destroying a Customer location" do
    visit customer_locations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Customer location was successfully destroyed"
  end
end
