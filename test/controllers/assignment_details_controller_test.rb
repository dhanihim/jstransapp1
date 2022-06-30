require "test_helper"

class AssignmentDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assignment_detail = assignment_details(:one)
  end

  test "should get index" do
    get assignment_details_url
    assert_response :success
  end

  test "should get new" do
    get new_assignment_detail_url
    assert_response :success
  end

  test "should create assignment_detail" do
    assert_difference('AssignmentDetail.count') do
      post assignment_details_url, params: { assignment_detail: { quantity: @assignment_detail.quantity, total: @assignment_detail.total } }
    end

    assert_redirected_to assignment_detail_url(AssignmentDetail.last)
  end

  test "should show assignment_detail" do
    get assignment_detail_url(@assignment_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_assignment_detail_url(@assignment_detail)
    assert_response :success
  end

  test "should update assignment_detail" do
    patch assignment_detail_url(@assignment_detail), params: { assignment_detail: { quantity: @assignment_detail.quantity, total: @assignment_detail.total } }
    assert_redirected_to assignment_detail_url(@assignment_detail)
  end

  test "should destroy assignment_detail" do
    assert_difference('AssignmentDetail.count', -1) do
      delete assignment_detail_url(@assignment_detail)
    end

    assert_redirected_to assignment_details_url
  end
end
