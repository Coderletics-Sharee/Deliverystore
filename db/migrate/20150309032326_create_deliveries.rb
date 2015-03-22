class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.text :item
      t.decimal :price
      t.text :description
      t.string :image_url

      t.timestamps null: false
    end
  end
end
