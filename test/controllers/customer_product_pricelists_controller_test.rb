require "test_helper"

class CustomerProductPricelistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_product_pricelist = customer_product_pricelists(:one)
  end

  test "should get index" do
    get customer_product_pricelists_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_product_pricelist_url
    assert_response :success
  end

  test "should create customer_product_pricelist" do
    assert_difference('CustomerProductPricelist.count') do
      post customer_product_pricelists_url, params: { customer_product_pricelist: { active: @customer_product_pricelist.active, description: @customer_product_pricelist.description, per20fr: @customer_product_pricelist.per20fr, per20ft: @customer_product_pricelist.per20ft, per20od: @customer_product_pricelist.per20od, per21ft: @customer_product_pricelist.per21ft, per40fr: @customer_product_pricelist.per40fr, per40ft: @customer_product_pricelist.per40ft, ppncategory: @customer_product_pricelist.ppncategory } }
    end

    assert_redirected_to customer_product_pricelist_url(CustomerProductPricelist.last)
  end

  test "should show customer_product_pricelist" do
    get customer_product_pricelist_url(@customer_product_pricelist)
    assert_response :success
  end

  test "should get edit" do
    get edit_customer_product_pricelist_url(@customer_product_pricelist)
    assert_response :success
  end

  test "should update customer_product_pricelist" do
    patch customer_product_pricelist_url(@customer_product_pricelist), params: { customer_product_pricelist: { active: @customer_product_pricelist.active, description: @customer_product_pricelist.description, per20fr: @customer_product_pricelist.per20fr, per20ft: @customer_product_pricelist.per20ft, per20od: @customer_product_pricelist.per20od, per21ft: @customer_product_pricelist.per21ft, per40fr: @customer_product_pricelist.per40fr, per40ft: @customer_product_pricelist.per40ft, ppncategory: @customer_product_pricelist.ppncategory } }
    assert_redirected_to customer_product_pricelist_url(@customer_product_pricelist)
  end

  test "should destroy customer_product_pricelist" do
    assert_difference('CustomerProductPricelist.count', -1) do
      delete customer_product_pricelist_url(@customer_product_pricelist)
    end

    assert_redirected_to customer_product_pricelists_url
  end
end
