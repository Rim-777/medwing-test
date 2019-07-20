class Thermostat < ApplicationRecord
  has_many :readings, inverse_of: :thermostat
end
