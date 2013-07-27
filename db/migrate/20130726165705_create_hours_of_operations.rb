class CreateHoursOfOperations < ActiveRecord::Migration
  def change
    create_table :hours_of_operations do |t|
      t.integer :cart_id
      t.integer :day
      t.time :open
      t.time :close
      t.boolean :closed

      t.timestamps
    end
  end
end
