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

  def item_discount(item_id)
    merchant = Item.find(item_id).merchant
    quantity = @contents[item_id.to_s]
    discount = merchant.discounts.where('required_quantity <= ?', quantity).order(required_quantity: :DESC).limit(1).first
  end

  def item_discount_percentage(item_id)
    item_discount(item_id).percentage/100.to_f
  end

  def available_discount?(item_id)
    !item_discount(item_id).nil?
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += subtotal_of(item_id)
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    quantity = @contents[item_id.to_s]
    unit_price = Item.find(item_id).price

    if available_discount?(item_id)
      (unit_price * quantity) - (unit_price * quantity) * item_discount_percentage(item_id)
    else
      unit_price * quantity
    end
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end
