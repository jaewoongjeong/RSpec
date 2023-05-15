=begin

- This test consists of following steps:
  1. It creates a mock user for the test using "instance_double"
  2. Then we let RSpec know that this mock user should receive a call to the "geocode" method at some point
      in the test.
  3. Finally, we call the background job itself, via "perform_now". This allows to test for results
      immediately.

=end

require 'rails_helper'

RSpec.describe GeocodeUserJob, type: :job do
  it "calls geocode on the user" do
    user = instance_double("User")
    expect(user).to receive(:geocode)
    GeocodeUserJob.perform_now(user)
  end
end
