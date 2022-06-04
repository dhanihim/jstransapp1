require "test_helper"

class CustomerLocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_location = customer_locations(:one)
  end

  test "should get index" do
    get customer_locations_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_location_url
    assert_response :success
  end

  test "should create customer_location" do
    assert_difference('CustomerLocation.count') do
      post customer_locations_url, params: { customer_location: { active: @customer_location.active, address: @customer_location.address, description: @customer_location.description } }
    end

    assert_redirected_to customer_location_url(CustomerLocation.last)
  end

  test "should show customer_location" do
    get customer_location_url(@customer_location)
    assert_response :success
  end

  test "should get edit" do
    get edit_customer_location_url(@customer_location)
    assert_response :success
  end

  test "should update customer_location" do
    patch customer_location_url(@customer_location), params: { customer_location: { active: @customer_location.active, address: @customer_location.address, description: @customer_location.description } }
    assert_redirected_to customer_location_url(@customer_location)
  end

  test "should destroy customer_location" do
    assert_difference('CustomerLocation.count', -1) do
      delete customer_location_url(@customer_location)
    end

    assert_redirected_to customer_locations_url
  end
end
