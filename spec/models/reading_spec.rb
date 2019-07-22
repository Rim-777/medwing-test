require 'rails_helper'
RSpec.describe Reading, type: :model do
  it {should belong_to(:thermostat).inverse_of(:readings)}
end
