class AddImageToCart < ActiveRecord::Migration
  def change
    add_column :carts, :cart_picture, :string
  end
end
