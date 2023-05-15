=begin

- ActiveJob is a framework for declaring jobs and making them run on a variety of queuing backends.

=end

require 'rails_helper'

RSpec.feature "SignIns", type: :feature do
  let (:user) { FactoryBot.create(:user) }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  scenario "user signs in" do
    visit root_path
    click_link "Sign In"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    # "have_enqueued_job" has been used to check that the correct job has been called with the correct input
    expect {
      GeocodeUserJob.perform_later(user)
    }.to have_enqueued_job.with(user)
  end
end
