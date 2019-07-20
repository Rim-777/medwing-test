class CreateReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :readings do |t|
      t.integer :thermostat_id, index: true, foreign_key: true
      t.integer :tracking_number,  index: {unique: true}, null: false
      t.float :temperature, null: false
      t.float :humidity, null: false
      t.float :battery_charge, null: false
      t.index([:thermostat_id, :tracking_number])

      t.timestamps
    end
  end
end
