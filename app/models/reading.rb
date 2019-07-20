class Reading < ApplicationRecord
  belongs_to :thermostat, inverse_of: :readings
end
