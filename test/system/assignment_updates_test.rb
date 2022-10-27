require "application_system_test_case"

class AssignmentUpdatesTest < ApplicationSystemTestCase
  setup do
    @assignment_update = assignment_updates(:one)
  end

  test "visiting the index" do
    visit assignment_updates_url
    assert_selector "h1", text: "Assignment Updates"
  end

  test "creating a Assignment update" do
    visit assignment_updates_url
    click_on "New Assignment Update"

    fill_in "Uid", with: @assignment_update.uid
    click_on "Create Assignment update"

    assert_text "Assignment update was successfully created"
    click_on "Back"
  end

  test "updating a Assignment update" do
    visit assignment_updates_url
    click_on "Edit", match: :first

    fill_in "Uid", with: @assignment_update.uid
    click_on "Update Assignment update"

    assert_text "Assignment update was successfully updated"
    click_on "Back"
  end

  test "destroying a Assignment update" do
    visit assignment_updates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Assignment update was successfully destroyed"
  end
end
