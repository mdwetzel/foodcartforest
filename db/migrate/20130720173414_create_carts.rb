class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.text :description
      t.string :name

      t.timestamps
    end
  end
end
