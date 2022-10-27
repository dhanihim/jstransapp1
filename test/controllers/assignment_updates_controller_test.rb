require "test_helper"

class AssignmentUpdatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @assignment_update = assignment_updates(:one)
  end

  test "should get index" do
    get assignment_updates_url
    assert_response :success
  end

  test "should get new" do
    get new_assignment_update_url
    assert_response :success
  end

  test "should create assignment_update" do
    assert_difference('AssignmentUpdate.count') do
      post assignment_updates_url, params: { assignment_update: { uid: @assignment_update.uid } }
    end

    assert_redirected_to assignment_update_url(AssignmentUpdate.last)
  end

  test "should show assignment_update" do
    get assignment_update_url(@assignment_update)
    assert_response :success
  end

  test "should get edit" do
    get edit_assignment_update_url(@assignment_update)
    assert_response :success
  end

  test "should update assignment_update" do
    patch assignment_update_url(@assignment_update), params: { assignment_update: { uid: @assignment_update.uid } }
    assert_redirected_to assignment_update_url(@assignment_update)
  end

  test "should destroy assignment_update" do
    assert_difference('AssignmentUpdate.count', -1) do
      delete assignment_update_url(@assignment_update)
    end

    assert_redirected_to assignment_updates_url
  end
end
