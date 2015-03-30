class Purchase < ActiveRecord::Base
	belongs_to :delivery
belongs_to :buyer, class_name: 'User'
	def change
    create_table :purchases do |t|
      t.integer :delivery_id
      t.integer :buyer_id
      t.timestamps
    end
    add_index :purchases, [:delivery_id, :buyer_id], unique: true
  end
end
