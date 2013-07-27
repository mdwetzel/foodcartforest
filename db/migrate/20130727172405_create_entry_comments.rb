class CreateEntryComments < ActiveRecord::Migration
  def change
    create_table :entry_comments do |t|
      t.integer :user_id
      t.text :body
      t.string :title
      t.integer :entry_id

      t.timestamps
    end
  end
end
