require 'dry/schema'

NewReadingSchema = Dry::Schema.Params do
    required(:temperature).filled(:float)
    required(:humidity).filled(:float)
    required(:battery_charge).filled(:float)
end
