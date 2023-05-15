=begin

- Note belongs to both Project and User
- Creating a Note creates a test data for "project" and "user" also!

=end

FactoryBot.define do
  factory :note do
    message "My important note."
    association :project
    user { project.owner }

    trait :with_attachment do
      attachment { File.new("#{Rails.root}/spec/files/attachment.jpg") }
    end
  end
end
