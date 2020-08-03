class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant
  end

  def new
    @discount = Discount.new
  end

  def create
    @merchant = current_user.merchant
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      redirect_to '/merchant/discounts'
    else
      generate_flash(@discount)
      render :new
    end
  end

  private

  def discount_params
    params.permit(:item_name, :required_quantity, :percentage)
  end

end
