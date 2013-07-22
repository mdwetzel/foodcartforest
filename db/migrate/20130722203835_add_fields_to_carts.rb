class AddFieldsToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :location, :string
    add_column :carts, :phone, :string
    add_column :carts, :website, :string
    add_column :carts, :facebook, :string
    add_column :carts, :twitter, :string
  end
end
