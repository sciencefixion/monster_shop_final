class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :item_name,
                        :required_quantity,
                        :percentage
end
