require "application_system_test_case"

class ShipmentsTest < ApplicationSystemTestCase
  setup do
    @shipment = shipments(:one)
  end

  test "visiting the index" do
    visit shipments_url
    assert_selector "h1", text: "Shipments"
  end

  test "creating a Shipment" do
    visit shipments_url
    click_on "New Shipment"

    fill_in "Active", with: @shipment.active
    fill_in "Actualarrival", with: @shipment.actualarrival
    fill_in "Actualdeparture", with: @shipment.actualdeparture
    fill_in "Description", with: @shipment.description
    fill_in "Estimatedarrival", with: @shipment.estimatedarrival
    fill_in "Estimateddeparture", with: @shipment.estimateddeparture
    fill_in "Shipname", with: @shipment.shipname
    fill_in "Uid", with: @shipment.uid
    fill_in "Voyage", with: @shipment.voyage
    click_on "Create Shipment"

    assert_text "Shipment was successfully created"
    click_on "Back"
  end

  test "updating a Shipment" do
    visit shipments_url
    click_on "Edit", match: :first

    fill_in "Active", with: @shipment.active
    fill_in "Actualarrival", with: @shipment.actualarrival
    fill_in "Actualdeparture", with: @shipment.actualdeparture
    fill_in "Description", with: @shipment.description
    fill_in "Estimatedarrival", with: @shipment.estimatedarrival
    fill_in "Estimateddeparture", with: @shipment.estimateddeparture
    fill_in "Shipname", with: @shipment.shipname
    fill_in "Uid", with: @shipment.uid
    fill_in "Voyage", with: @shipment.voyage
    click_on "Update Shipment"

    assert_text "Shipment was successfully updated"
    click_on "Back"
  end

  test "destroying a Shipment" do
    visit shipments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shipment was successfully destroyed"
  end
end
