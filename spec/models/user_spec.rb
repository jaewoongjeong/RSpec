=begin

- The application code should support what we are telling RSpec to test!!!
- Various Matchers:
  - be_valid, eq, include, be_empty
- "is_expected" = "expect(something)"
- Shoulda Matchers
  - validate_presence_of
  - validate_uniqueness_of

- VCR works by watching for external HTTP requests coming from your Ruby code.
  - You'll need to create a cassette onto which to record the HTTP transaction.
  - Future tests making the same request will use data from the file, instead of making another network request
    to the external API

- WebMock is the HTTP stubbing library that VCR uses behind the scenes when it records each transaction.

=end

require 'rails_helper'

# List out a set of things a model named "User" is expected to do
RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is valid with a first name, last name and email, and password" do
    user = User.new(
      first_name: "Aaron",
      last_name:  "Sumner",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    # RSpec matcher called "be_valid" compares the object to the matcher
    expect(user).to be_valid
  end

  # It is invalid without a first name
  it { is_expected.to validate_presence_of :first_name }
  # It is invalid without a last name
  it { is_expected.to validate_presence_of :last_name }
  # It is invalid without an email address
  it { is_expected.to validate_presence_of :email }
  # It is invalid with a duplicate email address
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it "returns a user's full name as a string" do
    user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
    expect(user.name).to eq "John Doe"
  end

  it "sends a welcome email on account creation" do
    allow(UserMailer).to \
      receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end

  it "performs geocoding", vcr: true do
    user = FactoryBot.create(:user, last_sign_in_ip: "161.185.207.20")
    expect {
      user.geocode
    }.to change(user, :location).
      from(nil).
      to("Brooklyn, New York, US")
  end
end
