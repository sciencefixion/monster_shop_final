class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :required_quantity,
                        :percentage
end
