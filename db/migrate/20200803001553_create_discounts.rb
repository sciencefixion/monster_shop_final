class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :item_name
      t.integer :required_quantity
      t.integer :percentage
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
