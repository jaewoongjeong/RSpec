require 'rails_helper'

RSpec.feature "Notes", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project) {
    FactoryBot.create(:project,
                      name: "RSpec tutorial",
                      owner: user)
  }

  scenario "user uploads an attachment" do
    sign_in user
    visit project_path(project)
    save_and_open_page
    click_link "Add Note"
    fill_in "Message", with: "My book cover"
    # Capybara's attach_file method. (Form field label, Path to a test file's location)
    attach_file "Attachment", "#{Rails.root}/spec/files/attachment.jpg"
    click_button "Create Note"
    expect(page).to have_content "Note was successfully created"
    expect(page).to have_content "My book cover"
    expect(page).to have_content "attachment.jpg (image/jpeg"
    end
  end