require "test_helper"

class CustomerLocationPricelistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_location_pricelist = customer_location_pricelists(:one)
  end

  test "should get index" do
    get customer_location_pricelists_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_location_pricelist_url
    assert_response :success
  end

  test "should create customer_location_pricelist" do
    assert_difference('CustomerLocationPricelist.count') do
      post customer_location_pricelists_url, params: { customer_location_pricelist: { active: @customer_location_pricelist.active, customer_location_from: @customer_location_pricelist.customer_location_from, customer_location_to: @customer_location_pricelist.customer_location_to, description: @customer_location_pricelist.description, per20fr: @customer_location_pricelist.per20fr, per20ft: @customer_location_pricelist.per20ft, per20od: @customer_location_pricelist.per20od, per21ft: @customer_location_pricelist.per21ft, per40fr: @customer_location_pricelist.per40fr, per40ft: @customer_location_pricelist.per40ft, ppncategory: @customer_location_pricelist.ppncategory } }
    end

    assert_redirected_to customer_location_pricelist_url(CustomerLocationPricelist.last)
  end

  test "should show customer_location_pricelist" do
    get customer_location_pricelist_url(@customer_location_pricelist)
    assert_response :success
  end

  test "should get edit" do
    get edit_customer_location_pricelist_url(@customer_location_pricelist)
    assert_response :success
  end

  test "should update customer_location_pricelist" do
    patch customer_location_pricelist_url(@customer_location_pricelist), params: { customer_location_pricelist: { active: @customer_location_pricelist.active, customer_location_from: @customer_location_pricelist.customer_location_from, customer_location_to: @customer_location_pricelist.customer_location_to, description: @customer_location_pricelist.description, per20fr: @customer_location_pricelist.per20fr, per20ft: @customer_location_pricelist.per20ft, per20od: @customer_location_pricelist.per20od, per21ft: @customer_location_pricelist.per21ft, per40fr: @customer_location_pricelist.per40fr, per40ft: @customer_location_pricelist.per40ft, ppncategory: @customer_location_pricelist.ppncategory } }
    assert_redirected_to customer_location_pricelist_url(@customer_location_pricelist)
  end

  test "should destroy customer_location_pricelist" do
    assert_difference('CustomerLocationPricelist.count', -1) do
      delete customer_location_pricelist_url(@customer_location_pricelist)
    end

    assert_redirected_to customer_location_pricelists_url
  end
end
