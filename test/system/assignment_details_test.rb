require "application_system_test_case"

class AssignmentDetailsTest < ApplicationSystemTestCase
  setup do
    @assignment_detail = assignment_details(:one)
  end

  test "visiting the index" do
    visit assignment_details_url
    assert_selector "h1", text: "Assignment Details"
  end

  test "creating a Assignment detail" do
    visit assignment_details_url
    click_on "New Assignment Detail"

    fill_in "Quantity", with: @assignment_detail.quantity
    fill_in "Total", with: @assignment_detail.total
    click_on "Create Assignment detail"

    assert_text "Assignment detail was successfully created"
    click_on "Back"
  end

  test "updating a Assignment detail" do
    visit assignment_details_url
    click_on "Edit", match: :first

    fill_in "Quantity", with: @assignment_detail.quantity
    fill_in "Total", with: @assignment_detail.total
    click_on "Update Assignment detail"

    assert_text "Assignment detail was successfully updated"
    click_on "Back"
  end

  test "destroying a Assignment detail" do
    visit assignment_details_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Assignment detail was successfully destroyed"
  end
end
