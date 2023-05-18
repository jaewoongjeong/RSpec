=begin

- FactoryBot is a library that provides factory methods to create test fixtures for automated software testing
- You can create a new user by calling "FactoryBot.create(:user)" or "FactoryBot.build(:user)"
  - Build instantiates, but not saves
  - Create instantiates and also saves
- FactoryBot supports "sequences" where it increments and injects a counter into the attribute that needs
  to be unique, each time it creates a new object from a factory.
- "factory :user, aliases: [:owner]" tells that User is also referred to as "owner"

=end

FactoryBot.define do
  # Alias of User = owner
  factory :user, aliases: [:owner] do
    first_name "Aaron"
    last_name  "Sumner"
    sequence(:email) { |n| "tester#{n}@example.com" }
    password "123456"
  end
end
