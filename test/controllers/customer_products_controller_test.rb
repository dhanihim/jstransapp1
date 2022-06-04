require "test_helper"

class CustomerProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_product = customer_products(:one)
  end

  test "should get index" do
    get customer_products_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_product_url
    assert_response :success
  end

  test "should create customer_product" do
    assert_difference('CustomerProduct.count') do
      post customer_products_url, params: { customer_product: { active: @customer_product.active, description: @customer_product.description, name: @customer_product.name, uom: @customer_product.uom } }
    end

    assert_redirected_to customer_product_url(CustomerProduct.last)
  end

  test "should show customer_product" do
    get customer_product_url(@customer_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_customer_product_url(@customer_product)
    assert_response :success
  end

  test "should update customer_product" do
    patch customer_product_url(@customer_product), params: { customer_product: { active: @customer_product.active, description: @customer_product.description, name: @customer_product.name, uom: @customer_product.uom } }
    assert_redirected_to customer_product_url(@customer_product)
  end

  test "should destroy customer_product" do
    assert_difference('CustomerProduct.count', -1) do
      delete customer_product_url(@customer_product)
    end

    assert_redirected_to customer_products_url
  end
end
