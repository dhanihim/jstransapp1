require "test_helper"

class ShipmentHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shipment_history = shipment_histories(:one)
  end

  test "should get index" do
    get shipment_histories_url
    assert_response :success
  end

  test "should get new" do
    get new_shipment_history_url
    assert_response :success
  end

  test "should create shipment_history" do
    assert_difference('ShipmentHistory.count') do
      post shipment_histories_url, params: { shipment_history: { description: @shipment_history.description, shipment_from_id: @shipment_history.shipment_from_id, shipment_to_id: @shipment_history.shipment_to_id } }
    end

    assert_redirected_to shipment_history_url(ShipmentHistory.last)
  end

  test "should show shipment_history" do
    get shipment_history_url(@shipment_history)
    assert_response :success
  end

  test "should get edit" do
    get edit_shipment_history_url(@shipment_history)
    assert_response :success
  end

  test "should update shipment_history" do
    patch shipment_history_url(@shipment_history), params: { shipment_history: { description: @shipment_history.description, shipment_from_id: @shipment_history.shipment_from_id, shipment_to_id: @shipment_history.shipment_to_id } }
    assert_redirected_to shipment_history_url(@shipment_history)
  end

  test "should destroy shipment_history" do
    assert_difference('ShipmentHistory.count', -1) do
      delete shipment_history_url(@shipment_history)
    end

    assert_redirected_to shipment_histories_url
  end
end
