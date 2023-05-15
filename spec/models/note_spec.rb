=begin

- "before" block
  - Code inside "before" block is run before code inside individual tests
  - It is scoped within a "describe" or "context" block

- Unlike "let", "let!" does NOT lazy load. (It runs the block right away)

=end

require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  it "is valid with a user, project, and message" do
    note = Note.new(
      message: "This is a sample note.",
      user: user,
      project: project,
    )
    expect(note).to be_valid
  end

  it "is invalid without a message" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  it { is_expected.to have_attached_file(:attachment) }

  describe "search message for a term" do
    let!(:note1) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the first note.",
      )
    }

    let!(:note2) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "This is the second note.",
      )
    }

    let!(:note3) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "First, preheat the oven.",
      )
    }

    context "when a match is found" do
      it "returns notes that match the search term" do
        expect(Note.search("first")).to include(note1, note3)
        expect(Note.search("first")).to_not include(note2)
      end
    end

    context "when no match is found" do
      it "returns an empty collection" do
        expect(Note.search("message")).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end

  it "delegates name to the user who created it" do
    # "double" or "instance_double" is NOT a real User object
    user = instance_double("User", name: "Fake User")
    note = Note.new
    # This line tells the test runner that, at some point within the scope of the test, our code is going to call note.user.
    # When that happens, instead of finding the value of note.user_id, looking up the value in the database for that User,
    # and returning the found User object, it just return the Double called user instead.
    allow(note).to receive(:user).and_return(user)
    expect(note.user_name).to eq "Fake User"
  end
end
