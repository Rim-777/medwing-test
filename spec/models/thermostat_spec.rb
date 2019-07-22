require 'rails_helper'
RSpec.describe Thermostat, type: :model do
  it {should have_many(:readings).inverse_of(:thermostat)}
end
