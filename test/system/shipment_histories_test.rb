require "application_system_test_case"

class ShipmentHistoriesTest < ApplicationSystemTestCase
  setup do
    @shipment_history = shipment_histories(:one)
  end

  test "visiting the index" do
    visit shipment_histories_url
    assert_selector "h1", text: "Shipment Histories"
  end

  test "creating a Shipment history" do
    visit shipment_histories_url
    click_on "New Shipment History"

    fill_in "Description", with: @shipment_history.description
    fill_in "Shipment from", with: @shipment_history.shipment_from_id
    fill_in "Shipment to", with: @shipment_history.shipment_to_id
    click_on "Create Shipment history"

    assert_text "Shipment history was successfully created"
    click_on "Back"
  end

  test "updating a Shipment history" do
    visit shipment_histories_url
    click_on "Edit", match: :first

    fill_in "Description", with: @shipment_history.description
    fill_in "Shipment from", with: @shipment_history.shipment_from_id
    fill_in "Shipment to", with: @shipment_history.shipment_to_id
    click_on "Update Shipment history"

    assert_text "Shipment history was successfully updated"
    click_on "Back"
  end

  test "destroying a Shipment history" do
    visit shipment_histories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shipment history was successfully destroyed"
  end
end
