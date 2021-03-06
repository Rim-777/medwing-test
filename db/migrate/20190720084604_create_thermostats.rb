class CreateThermostats < ActiveRecord::Migration[5.2]
  def change
    create_table :thermostats do |t|
      t.text :household_token, index: {unique: true}, null: false
      t.text :address
      t.timestamps
    end
  end
end
