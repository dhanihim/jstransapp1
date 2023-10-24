require "application_system_test_case"

class FinanceUpdatesTest < ApplicationSystemTestCase
  setup do
    @finance_update = finance_updates(:one)
  end

  test "visiting the index" do
    visit finance_updates_url
    assert_selector "h1", text: "Finance Updates"
  end

  test "creating a Finance update" do
    visit finance_updates_url
    click_on "New Finance Update"

    fill_in "Description", with: @finance_update.description
    fill_in "Document path", with: @finance_update.document_path
    fill_in "Uid", with: @finance_update.uid
    click_on "Create Finance update"

    assert_text "Finance update was successfully created"
    click_on "Back"
  end

  test "updating a Finance update" do
    visit finance_updates_url
    click_on "Edit", match: :first

    fill_in "Description", with: @finance_update.description
    fill_in "Document path", with: @finance_update.document_path
    fill_in "Uid", with: @finance_update.uid
    click_on "Update Finance update"

    assert_text "Finance update was successfully updated"
    click_on "Back"
  end

  test "destroying a Finance update" do
    visit finance_updates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Finance update was successfully destroyed"
  end
end
