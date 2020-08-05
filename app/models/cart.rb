class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def check_for_discount(item_id)
    merchant = Item.find(item_id).merchant
    quantity = @contents[item_id.to_s]
    discount = merchant.discounts.where('required_quantity <= ?', quantity).order(required_quantity: :DESC).limit(1)
  end

  def item_discount_percentage(item_id)
    discount = check_for_discount(item_id).first
    discount.percentage/100.to_f
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    total_before_discount = @contents[item_id.to_s] * Item.find(item_id).price
    
    # check_for_discount(item_id) ? (total_before_discount - total_discount) : total_before_discount
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end
