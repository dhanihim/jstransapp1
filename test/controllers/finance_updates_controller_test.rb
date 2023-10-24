require "test_helper"

class FinanceUpdatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @finance_update = finance_updates(:one)
  end

  test "should get index" do
    get finance_updates_url
    assert_response :success
  end

  test "should get new" do
    get new_finance_update_url
    assert_response :success
  end

  test "should create finance_update" do
    assert_difference('FinanceUpdate.count') do
      post finance_updates_url, params: { finance_update: { description: @finance_update.description, document_path: @finance_update.document_path, uid: @finance_update.uid } }
    end

    assert_redirected_to finance_update_url(FinanceUpdate.last)
  end

  test "should show finance_update" do
    get finance_update_url(@finance_update)
    assert_response :success
  end

  test "should get edit" do
    get edit_finance_update_url(@finance_update)
    assert_response :success
  end

  test "should update finance_update" do
    patch finance_update_url(@finance_update), params: { finance_update: { description: @finance_update.description, document_path: @finance_update.document_path, uid: @finance_update.uid } }
    assert_redirected_to finance_update_url(@finance_update)
  end

  test "should destroy finance_update" do
    assert_difference('FinanceUpdate.count', -1) do
      delete finance_update_url(@finance_update)
    end

    assert_redirected_to finance_updates_url
  end
end
