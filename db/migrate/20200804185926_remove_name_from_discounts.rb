class RemoveNameFromDiscounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :discounts, :item_name, :string
  end
end
