class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :delivery_id
      t.integer :buyer_id

      t.timestamps null: false
    end
  end
end
